class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = Review.new(params[:review].permit(:text, :rating))
    review.user = current_user
    review.video = @video
    if review.save
      redirect_to(video_path(@video))
    else
      @reviews = @video.reviews
      render 'videos/show'
    end
  end
end