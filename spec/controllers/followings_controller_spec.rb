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

      it 'redirects to the users_path' do
        post :create, follow_id: other_user
        expect(response).to redirect_to users_path
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

      it 'redirects to the users_path' do
        delete :destroy, id: following.id
        expect(response).to redirect_to users_path
      end
    end

    it_behaves_like 'requires sign in' do
      let(:action) { post :destroy, id: 1 }
    end
  end
end


