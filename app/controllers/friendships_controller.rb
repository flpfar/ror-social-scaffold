class FriendshipsController < ApplicationController
  def index
    @active_friends = current_user.active_friends
    @pending_friends = current_user.pending_friends
    @friendship_requests = current_user.friendship_requests
  end

  def new; end

  def create
    user = User.find(current_user.id)

    friendship = user.friendships.new(user_id: current_user.id, friend_id: params[:id], accepted: false)

    if friendship.save
      flash[:notice] = 'Invitation sent'
    else
      flash[:alert] = 'Invitation failed'
    end

    redirect_to users_path
  end
end
