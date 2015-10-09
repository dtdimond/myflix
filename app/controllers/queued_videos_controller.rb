class QueuedVideosController < ApplicationController
  before_action :require_user

  def index
    @queued_videos = current_user.queued_videos
  end
end