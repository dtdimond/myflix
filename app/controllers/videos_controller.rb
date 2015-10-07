class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews.sort_by { |r| r.created_at }.reverse!
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end