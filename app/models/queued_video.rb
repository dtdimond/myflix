class QueuedVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :order, presence: true
  validates_numericality_of :order, {only_integer: true}

  def review_rating
    review = Review.find_by(user: user, video: video)
    if review
      review.rating
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
