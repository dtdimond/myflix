require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    context 'with valid inputs' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'creates a new user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to the login path' do
        expect(response).to redirect_to(login_path)
      end

    end

    context 'with invalid inputs' do
      before { post :create, user: { email: "test@example.com" } }

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET show' do
    it 'sets @user' do
      set_current_user
      get :show, id: Fabricate(:user).id
      expect(assigns(:user)).to eq(User.second)
    end

    it 'renders the show template' do
      set_current_user
      get :show, id: Fabricate(:user).id
      expect(response).to render_template(:show)
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: 1 }
    end
  end
end


