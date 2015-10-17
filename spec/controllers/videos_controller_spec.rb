require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let!(:video) { Fabricate(:video) }
    before { set_current_user }

    it 'sets the @video' do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'sets the @reviews with most recent first' do
      get :show, id: video.id
      expect(assigns(:reviews)).to eq(video.reviews.sort_by { |r| r.created_at }.reverse!)
    end

    it 'renders the show template' do
      get :show, id: video.id
      expect(response).to render_template(:show)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end
  end

  describe 'GET search' do
    before { set_current_user }

    it 'sets @videos' do
      video = Fabricate(:video, title: "Finding Nemo")
      video2 = Fabricate(:video, title: "Nemosis")
      video3 = Fabricate(:video, title: "Finding Dory")

      get :search, search_term: "Nem"
      expect(assigns(:videos)).to eq([video, video2])
    end

    it 'renders the search template' do
      video = Fabricate(:video, title: "Finding Nemo")
      get :search, search_term: "Nem"
      expect(response).to render_template(:search)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :search, search_term: "Nem" }
    end
  end
end
