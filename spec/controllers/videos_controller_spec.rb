require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    context 'with authentication' do
      before { session[:user_id] = Fabricate(:user) }

      it 'sets the @video' do
        video = Fabricate(:video)
        session[:user_id] = Fabricate(:user)

        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it 'renders the show template' do
        video = Fabricate(:video)
        session[:user_id] = Fabricate(:user)

        get :show, id: video.id
        expect(response).to render_template(:show)
      end
    end

    context 'without authentication' do
      it 'redirects to root' do
        get :show, id: 1
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET search' do
    context 'with authentication' do
      before { session[:user_id] = Fabricate(:user) }

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
    end

    context 'without authentication' do
      it 'redirects to root' do
        get :search, search_term: "Nem"
        expect(response).to redirect_to(root_path)
      end
    end
  end
end


