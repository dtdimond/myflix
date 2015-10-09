class QueuedVideo < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :order, presence: true
end