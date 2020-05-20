class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @active_friends = current_user.active_friends
    @pending_friends = current_user.pending_friends
    @friendship_requests = current_user.friendship_requests
  end

  def new; end

  def create
    user = User.find(current_user.id)
    friendship = user.friendships.new(user_id: current_user.id, friend_id: params[:id], accepted: false)

    if user.inverse_friendships.where(user_id: params[:id]).none? && friendship.save
      flash[:notice] = 'Invitation sent'
    else
      flash[:alert] = 'Invitation failed'
    end

    redirect_to users_path
  end

  def update
    requested_user_id = params[:id]
    friendship1 = Friendship.where(user_id: requested_user_id, friend_id: current_user.id)[0]
    friendship1.update(accepted: true)
    friendship2 = Friendship.create(user_id: current_user.id, friend_id: requested_user_id, accepted: true)

    if friendship1 && friendship2
      flash[:notice] = 'Friendship accepted!'
    else
      flash[:alert] = 'It was not possible to accept this friendship. Try again later.'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    friend_id_to_delete = params[:id]
    friendship1 = Friendship.where(user_id: current_user.id, friend_id: friend_id_to_delete)[0]
    friendship2 = Friendship.where(user_id: friend_id_to_delete, friend_id: current_user.id)[0]
    if friendship1 && friendship2
      friendship1.destroy
      friendship2.destroy
      flash[:notice] = 'Friendship removed'
    else
      flash[:alert] = 'It was not possible to remove this friendship. Try again later.'
    end
    redirect_to users_path
  end

  def reject
    friend_id_to_delete = params[:id]
    friendship = Friendship.where(user_id: friend_id_to_delete, friend_id: current_user.id)[0]
    if friendship
      friendship.destroy
      flash[:notice] = 'Friendship request rejected'
    else
      flash[:alert] = 'It was not possible to reject this friendship request. Try again later.'
    end
    redirect_to users_path
  end
end
