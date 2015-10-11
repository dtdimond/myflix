class QueuedVideosController < ApplicationController
  before_action :require_user

  def index
    @queued_videos = current_user.queued_videos
  end

  def create
    queue_video(params[:video_id])
    redirect_to queued_videos_path
  end

  def destroy
    queued_vid = QueuedVideo.find(params[:id])
    queued_vid.delete if queued_vid.user == current_user
    redirect_to queued_videos_path
  end

  private
  def queue_video(video_id)
     if video_not_yet_queued?(video_id)
       QueuedVideo.create(order: new_order,
                          video_id: video_id, user: current_user)
    end
  end

  def video_not_yet_queued?(video_id)
    QueuedVideo.find_by(video_id: video_id, user_id: current_user.id).nil?
  end

  def new_order
    max = QueuedVideo.where(user: current_user).maximum(:order)
    max ? max + 1 : 1
  end
end