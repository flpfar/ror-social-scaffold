class FrienshipsController < ApplicationController
  def new; end

  def create
    friend = User.find(params[:id])
    @user = User.find(current_user.id)

    @user.friends.create(friend)


    flash[:notice] = 'Invitation sent'
    redirect_to users_path
  end
end
