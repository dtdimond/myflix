class QueuedVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :order, presence: true
  validates_numericality_of :order, {only_integer: true}

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def rating
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

  private

  def review
    @review ||= Review.find_by(user: user, video: video)
  end
end
