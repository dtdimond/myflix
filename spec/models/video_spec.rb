require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '#search_by_title(search_term)' do
    it 'returns [] array if search_term is empty string' do
      Video.create(title: "Nemo", description: "Lost fishy.")
      expect(Video.search_by_title("")).to eq([])
    end

    it 'returns [] array if search_term is nil' do
      Video.create(title: "Nemo", description: "Lost fishy.")
      expect(Video.search_by_title(nil)).to eq([])
    end

    it 'returns [] array if no video matches search_term' do
      Video.create(title: "Nemo", description: "Lost fishy.")
      expect(Video.search_by_title("Brave")).to eq([])
    end

    it 'returns array of one video that matches search_term exactly' do
      Video.create(title: "Finding Nemo", description: "Lost fishy.")
      expect(Video.search_by_title("Finding Nemo")).to eq([Video.first])
    end

    it 'returns array of one video that matches search_term partially' do
      Video.create(title: "Finding Nemo", description: "Lost fishy.")
      expect(Video.search_by_title("N")).to eq([Video.first])
    end

    it 'returns array of all videos that match search_term ordered by title' do
      nemo = Video.create(title: "Nemo", description: "Lost fishy.")
      commander = Video.create(title: "Commander Nemo", description: "Probably not a real movie.")
      brave = Video.create(title: "Brave", description: "Pixar.")
      expect(Video.search_by_title("Nem")).to eq([commander, nemo])
    end
  end
end
