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

  def is_friend_of?(id)
    friends = friendships.where(friend_id: id)
    if friends.any?
      return true if friends.first[:accepted] 
    end    
    false
  end

  def is_invitation_sent?(id)
    return true if friendships.where(friend_id: id).any?
    false
  end  
end
