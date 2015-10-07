class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @review = Review.new(params[:review].permit(:text, :rating, :video), user: current_user)

  end
end