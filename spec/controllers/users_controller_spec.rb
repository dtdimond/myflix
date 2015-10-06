require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      #expect(assigns(:user)).to be_kind_of(User)
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    context 'when inputs are valid' do
      before { post :create, user: { email: "test@example.com", full_name: "Testy McTest", password: "Password" } }

      it 'creates a new user' do
        expect(User.first.email).to eq("test@example.com")
      end

      it 'redirects to the login path' do
        expect(response).to redirect_to(login_path)
      end

    end

    context 'when inputs are invalid' do
      before { post :create, user: { email: "test@example.com" } }

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end
end


