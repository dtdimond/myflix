require 'spec_helper'

describe QueuedVideo do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:order) }

  describe 'review_rating' do

    it 'returns the review rating if there is a review' do
      user = Fabricate(:user)
      review = Fabricate(:review, user: user)
      video = Fabricate(:video, reviews: [review])
      queued_video = Fabricate(:queued_video, user: user, video: video)

      expect(queued_video.review_rating).to eq(review.rating)
    end

    it 'returns "" if there is no review' do
      user = Fabricate(:user)
      video = Fabricate(:video, reviews: [])
      queued_video = Fabricate(:queued_video, user: user, video: video)

      expect(queued_video.review_rating).to eq("")
    end
  end

  describe 'video_title' do
    it 'returns the title of the associated video' do
      video = Fabricate(:video)
      queued_video = Fabricate(:queued_video, video: video)

      expect(queued_video.video_title).to eq(video.title)
    end
  end

  describe 'video_category_title' do
    it 'returns the category of the associated video' do
      video = Fabricate(:video)
      queued_video = Fabricate(:queued_video, video: video)

      expect(queued_video.video_category_title).to eq(video.category.title)
    end
  end
end















