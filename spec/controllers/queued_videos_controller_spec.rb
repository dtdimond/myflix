require 'spec_helper'

describe QueuedVideosController do
  describe 'GET index' do
    context 'with authentication' do
      let(:user) { Fabricate(:user) }
      let!(:queue1) { Fabricate(:queued_video, user: user) }
      let!(:queue2) { Fabricate(:queued_video, user: user) }

      before do
        session[:user_id] = user.id
        get :index
      end

      it 'sets @queued_videos if user authenticated' do
        expect(assigns(:queued_videos)).to eq([queue1, queue2])
      end

      it 'renders the index template if authenticated' do
        expect(response).to render_template(:index)
      end
    end

    it 'redirects to /login if not authenticated' do
      get :index
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'POST create' do
    context 'with authentication' do
      let(:user) { Fabricate(:user) }
      let!(:video1) { Fabricate(:video) }

      before do
        session[:user_id] = user.id
        post :create, video_id: video1
      end

      it 'creates a new queued_video if params valid' do
        expect(QueuedVideo.count).to eq(1)
      end

      it 'creates a new queued_video with order set to max order + 1' do
        expect(QueuedVideo.first.order).to eq(1)
      end

      it 'redirects to queued_videos#index' do
        expect(response).to redirect_to(queued_videos_path)
      end
    end

    context 'without authentication' do
      let(:video) { Fabricate(:video) }
      before { post :create, video_id: video.id }

      it 'does not create a new queued_video' do
        expect(QueuedVideo.count).to eq(0)
      end

      it 'redirects to /login' do
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
