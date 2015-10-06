require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'redirects to home_path if logged in' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to(home_path)
    end

    it 'renders new if not logged in' do
      get :new
      expect(response).to render_template(:new)
    end

  end

  describe 'POST create' do
    let(:user) { Fabricate.build(:user, email: "j@example.com", password: "password") }

    context '(authenticated)' do
      before do
        user.save
        post :create, email: "j@example.com", password: "password"
      end

      it 'stores user id in session' do
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to home_path' do
        expect(response).to redirect_to(home_path)
      end
    end

    context '(not authenticated)' do
      before do
        user.save
        post :create, email: "j@example.com", password: "wrongpassword"
      end

      it 'does not store user id in session' do
        expect(session[:user_id]).not_to eq(user.id)
      end

      it 'redirects to login_path' do
        expect(response).to redirect_to(login_path)
      end
    end
  end
end


