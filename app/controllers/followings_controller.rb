class FollowingsController < ApplicationController
  before_action :require_user

  def create
    @following = current_user.followings.build(follow_id: params[:follow_id])

    if @following.save
      flash[:success] = "You are now following #{@following.follow.full_name}!"
      redirect_to followings_path
    else
      flash[:danger] = "Sorry you were unable to follow that person."
      redirect_to followings_path
    end
  end

  def destroy
    @following = current_user.followings.find(params[:id])
    @following.destroy
    flash[:success] = "You're no longer following them."
    redirect_to followings_path
  end

  def index
    @followings = current_user.followings
  end
end