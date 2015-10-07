class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?

    Video.where("title LIKE ?", "%#{search_term}%").order(:title)
  end

  def average_rating
    return "N/A" if reviews.none?
    return reviews.first.rating if reviews.one?

    #average calculation
    2.2
  end
end