class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validate :not_self_friendship
  validates :user_id, uniqueness: { scope: :friend_id }

  def not_self_friendship
    errors.add(:friend_id, 'User can not send a self friendship request.') if user_id == friend_id
  end
end
