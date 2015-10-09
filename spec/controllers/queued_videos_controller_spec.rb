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
end
