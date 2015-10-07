class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: (0..5) }
  validates :text, presence: true
end