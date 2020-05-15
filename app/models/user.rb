class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships, foreign_key: 'friend_id'

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user, foreign_key: 'user_id'

  def friend_of?(id)
    friends = friendships.where(friend_id: id)
    if friends.any?
      return true if friends.first[:accepted]
    end
    false
  end

  def invitation_sent?(id)
    return true if friendships.where(friend_id: id).any?

    false
  end

  def invitation_received?(id)
    return true if inverse_friendships.where(user_id: id).any?

    false
  end

  def active_friends
    friends.where(friendships: { accepted: true })
  end

  def pending_friends
    friends.where(friendships: { accepted: false })
  end

  def friendship_requests
    inverse_friends.where(friendships: { accepted: false })
  end
end
