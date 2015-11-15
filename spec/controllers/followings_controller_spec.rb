require 'spec_helper'

describe FollowingsController do
  describe 'POST create' do
    context 'with authenticated user' do
      let(:other_user) { Fabricate(:user) }
      before { set_current_user }

      it 'creates a new following' do
        post :create, follow_id: other_user
        expect(Following.first.follow_id).to eq(other_user.id)
      end

      it 'sets the flash success' do
        post :create, follow_id: other_user
        expect(flash[:success]).not_to be_blank
      end

      it 'redirects to the followings_path' do
        post :create, follow_id: other_user
        expect(response).to redirect_to followings_path
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
  end

  describe 'DELETE destroy' do
    context 'with authenticated user' do
      let(:following) { Fabricate(:following, user: current_user) }
      before { set_current_user }

      it 'destroys the following' do
        delete :destroy, id: following.id
        expect(Following.first).to be_nil
      end

      it 'sets the flash success' do
        delete :destroy, id: following.id
        expect(flash[:success]).not_to be_blank
      end

      it 'redirects to the followings_path' do
        delete :destroy, id: following.id
        expect(response).to redirect_to followings_path
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :destroy, id: 1 }
    end
  end

  describe 'GET index' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    context 'with authenticated user' do
      let(:other_user) {Fabricate(:user)}
      before { set_current_user }

      it 'sets the @followings' do
        Fabricate(:following, user: current_user, follow: other_user)
        get :index
        expect(assigns(:followings)).to eq([Following.first])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end


