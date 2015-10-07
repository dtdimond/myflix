require 'spec_helper'

describe VideosController do
  describe 'POST create' do
    context 'with user logged in' do
      before { session[:user_id] = 1 }

      it 'saves the review if params are valid' do

      end
      it 'sets the success notice if params are valid'
      it 'renders the videos/show template if params are valid'

      it 'does not save the review if params are invalid'
      it 'sets the danger notice if params are invalid'
      it 'renders the videos/show template if params are invalid'
    end

    it 'redirects to login_path if user not logged in'
  end
end


