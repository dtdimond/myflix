require 'spec_helper'

describe QueuedVideo do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:order) }
  it { should validate_numericality_of(:order) }

  describe '#rating' do
    it 'returns the review rating if there is a review' do
      user = Fabricate(:user)
      review = Fabricate(:review, user: user)
      video = Fabricate(:video, reviews: [review])
      queued_video = Fabricate(:queued_video, user: user, video: video)

      expect(queued_video.rating).to eq(review.rating)
    end

    it 'returns "" if there is no review for the video' do
      user = Fabricate(:user)
      video = Fabricate(:video, reviews: [])
      queued_video = Fabricate(:queued_video, user: user, video: video)

      expect(queued_video.rating).to eq("")
    end

    it 'returns "" if there is a review for the video but not by the current_user' do
      user = Fabricate(:user)
      user2 = Fabricate(:user)
      review = Fabricate(:review, user: user2)
      video = Fabricate(:video, reviews: [review])
      queued_video = Fabricate(:queued_video, user: user, video: video)

      expect(queued_video.rating).to eq("")
    end
  end

  describe '#rating=' do
    it 'sets the review rating to new_rating if the review exists' do
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, rating: 3)
      video = Fabricate(:video, reviews: [review])
      queued_video = Fabricate(:queued_video, user: user, video: video)
      queued_video.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it 'creates a new review with new_rating if the review does not exist' do
      user = Fabricate(:user)
      video = Fabricate(:video, reviews: [])
      queued_video = Fabricate(:queued_video, user: user, video: video)
      queued_video.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it 'clears the review if nil is passed in' do
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, rating: 3)
      video = Fabricate(:video, reviews: [review])
      queued_video = Fabricate(:queued_video, user: user, video: video)
      queued_video.rating = nil
      expect(Review.first.rating).to be_nil
    end
  end

  describe '#video_title' do
    it 'returns the title of the associated video' do
      video = Fabricate(:video)
      queued_video = Fabricate(:queued_video, video: video)

      expect(queued_video.video_title).to eq(video.title)
    end
  end

  describe '#video_category_title' do
    it 'returns the category of the associated video' do
      video = Fabricate(:video)
      queued_video = Fabricate(:queued_video, video: video)

      expect(queued_video.video_category_title).to eq(video.category.title)
    end
  end
end
