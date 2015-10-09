class QueuedVideosController < ApplicationController
  before_action :require_user

  def index
    @queued_videos = QueuedVideo.where("user_id = ?", current_user.id)
  end
end