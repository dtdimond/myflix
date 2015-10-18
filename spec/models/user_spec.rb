require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queued_videos).order("queued_videos.order") }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }

  describe "#video_queued?" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'returns true if the user has the video queued' do
      queued_video = Fabricate(:queued_video, user: user, video: video)
      expect(user.video_queued? video).to be true
    end

    it 'returns false if the user does not have the video queued' do
      queued_video = Fabricate(:queued_video, user: user, video: video)
      expect(user.video_queued? video).to be true
    end

    it 'returns false if the video is nil' do
      queued_video = Fabricate(:queued_video, user: user, video: video)
      expect(user.video_queued? nil).to be false
    end

    it 'returns false if the video isnt queued but others are' do
      other_video = Fabricate(:video)
      queued_video = Fabricate(:queued_video, user: user, video: other_video)
      expect(user.video_queued? video).to be false
    end
  end
end
