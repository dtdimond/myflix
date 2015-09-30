require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe '#recent_videos' do
    it 'returns [] array if no videos in category' do
      horror = Category.create(title: "Horror", id: 1)
      psycho = Video.create(title: "Psycho", description: "stabby stabby", created_at: 2.days.ago)

      expect(horror.recent_videos).to eq([])
    end

    it 'returns all videos in category if less than 6 videos, ordered by created_at' do
      horror = Category.create(title: "Horror", id: 1)
      psycho = Video.create(title: "Psycho", description: "stabby stabby", created_at: 2.days.ago, category_id: 1)
      carrie = Video.create(title: "Carrie", description: "Original red reception", created_at: 1.days.ago, category_id: 1)

      expect(horror.recent_videos).to eq([carrie, psycho])
    end

    it 'returns 6 most recent videos if greater than or equal to 6 videos, orderd by created_at' do
      horror = Category.create(title: "Horror", id: 1)
      psycho = Video.create(title: "Psycho", description: "stabby stabby", created_at: 2.days.ago, category_id: 1)
      carrie = Video.create(title: "Carrie", description: "Original red reception", created_at: 1.days.ago, category_id: 1)
      scream = Video.create(title: "Scream", description: "Spooky mask", created_at: 5.days.ago, category_id: 1)
      scream2 = Video.create(title: "Scream 2", description: "More spooky mask", created_at: 29.days.ago, category_id: 1)
      scream3 = Video.create(title: "Scream 3", description: "Cash grab part 1", created_at: 21.days.ago, category_id: 1)
      scream4 = Video.create(title: "Scream 4", description: "Cash grab part 2", created_at: 7.days.ago, category_id: 1)
      scream5 = Video.create(title: "Scream 5", description: "Cash grab part3", created_at: 32.days.ago, category_id: 1)

      expect(horror.recent_videos).to eq([carrie, psycho, scream, scream4, scream3, scream2])
    end
  end
end