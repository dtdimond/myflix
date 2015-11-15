class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews
  has_many :queued_videos, -> { order("queued_videos.order") }
  has_many :followings
  has_many :follows, through: :followings

  validates :email, presence: true, uniqueness: true
  validates :password, on: :create, length: {minimum: 6}
  validates :full_name, presence: true

  def normalize_queued_videos_order
    self.queued_videos.each_with_index do |q_video, index|
      q_video.update_attributes(order: index + 1)
    end
  end

  def video_queued?(video)
    video ? (queued_videos & video.queued_videos).any? : false
  end

  def has_follower?(other_user)
    return false unless other_user
    !followings.find_by(follow_id: other_user.id).nil?
  end
end