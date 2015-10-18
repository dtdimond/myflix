require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    before { set_current_user }

    context 'and valid parameters' do
      let(:video) { Fabricate(:video) { reviews(count: 0) } }
      before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }

      it 'renders the videos/show template' do
        expect(response).to redirect_to(video)
      end

      it 'creates the review if params are valid' do
        expect(Review.count).to eq(1)
      end

      it 'associates the review with the video' do
        expect(Review.first.video).to eq(video)
      end

      it 'associates the review with the logged in user' do
        expect(Review.first.user).to eq(current_user)
      end

    end

    context 'and invalid parameters' do
     let(:video) { Fabricate(:video) }
     before { post :create, review: { text: "This is a review." }, video_id: video.id }

     it 'does not save the review' do
        #Note: video fabricator automatically creates 2 reviews
        expect(Review.count).to eq(2)
      end

      it 'sets @video' do
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        expect(assigns(:reviews)).to eq(video.reviews)
      end

      it 'renders the videos/show template' do
        expect(response).to render_template 'videos/show'
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create, review: { text: "This is a review." }, video_id: 0 }
    end
  end
end


