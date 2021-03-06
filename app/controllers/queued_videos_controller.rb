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
    if queued_vid.user == current_user
      queued_vid.delete
      current_user.normalize_queued_videos_order
    end
    redirect_to queued_videos_path
  end

  def update
    begin
      if params[:queued_videos]
        update_queued_videos(params[:queued_videos])
        current_user.normalize_queued_videos_order
      end
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position numbers."
    rescue
      flash[:danger] = "You can't do that."
    end

    redirect_to queued_videos_path
  end

  private
  def update_queued_videos(queued_videos_data)
    ActiveRecord::Base.transaction do
      queued_videos_data.each do |q_video_data|
        q_video = QueuedVideo.find(q_video_data[:id])
        if current_user == q_video.user
          q_video.update!(order: q_video_data[:order], rating: q_video_data[:rating])
        else
          #Error causes transaction to rollback
          raise 'Bad user exception'
        end
      end
    end
  end

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