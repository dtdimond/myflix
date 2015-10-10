class QueuedVideosController < ApplicationController
  before_action :require_user

  def index
    @queued_videos = current_user.queued_videos
  end

  def create
    QueuedVideo.create(order: max_order + 1,
                       video_id: params[:video_id], user: current_user)
    redirect_to queued_videos_path
  end


  private

  def max_order
    max = QueuedVideo.maximum(:order)
    if max
      max
    else
      0
    end
  end
end