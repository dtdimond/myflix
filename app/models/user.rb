class User < ActiveRecord::Base
  has_secure_password
  has_many :reviews
  has_many :queued_videos, -> { order("queued_videos.order") }

  validates :email, presence: true, uniqueness: true
  validates :password, on: :create, length: {minimum: 6}
  validates :full_name, presence: true

  def normalize_queued_videos_order
    self.queued_videos.each_with_index do |q_video, index|
      q_video.update_attributes(order: index + 1)
    end
  end
end