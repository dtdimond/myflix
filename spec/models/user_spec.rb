require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queued_videos).order("queued_videos.order") }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
end















