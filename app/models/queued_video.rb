class QueuedVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :order, presence: true

  def review_rating
    if video.reviews.any?
      Review.find_by(user: user, video: video).rating
    else
       ""
    end
  end

  def video_title
    self.video.title
  end

  def video_category_title
    self.video.category.title
  end

end
