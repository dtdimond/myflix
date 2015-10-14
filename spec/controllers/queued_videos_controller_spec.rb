require 'spec_helper'

describe QueuedVideosController do
  describe 'GET index' do
    context 'with authentication' do
      let(:user) { Fabricate(:user) }
      let!(:queue1) { Fabricate(:queued_video, order: 2, user: user) }
      let!(:queue2) { Fabricate(:queued_video, order: 1, user: user) }

      before do
        session[:user_id] = user.id
        get :index
      end

      it 'sets @queued_videos, ordered by order' do
        expect(assigns(:queued_videos)).to eq([queue2, queue1])
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    it 'redirects to the login_path if not authenticated' do
      get :index
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'POST create' do
    context 'with authentication' do
      let(:user) { Fabricate(:user) }
      let(:video1) { Fabricate(:video) }

      before do
        session[:user_id] = user.id
        post :create, video_id: video1
      end

      it 'creates a new queued_video' do
        expect(QueuedVideo.count).to eq(1)
      end

      it 'creates a new queued_video with order set to max order + 1' do
        expect(QueuedVideo.first.order).to eq(1)
      end

      it 'creates a new queued_video associated with logged in user' do
        expect(QueuedVideo.first.user).to eq(user)
      end

      it 'creates a new queued_video associated with the video' do
        expect(QueuedVideo.first.video).to eq(video1)
      end

      it 'does not create a new queued_video if the video is already queued for user' do
        post :create, video_id: video1 #duplicate call of post create for this test
        expect(QueuedVideo.count).to eq(1)
      end

      it 'redirects to queued_videos_path' do
        expect(response).to redirect_to(queued_videos_path)
      end
    end

    context 'without authentication' do
      let(:video) { Fabricate(:video) }
      before { post :create, video_id: video.id }

      it 'does not create a new queued_video' do
        expect(QueuedVideo.count).to eq(0)
      end

      it 'redirects to login_path' do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authentication' do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'deletes the queued_video record' do
        queue = Fabricate(:queued_video, user: user)
        delete :destroy, id: queue.id
        expect(QueuedVideo.count).to eq(0)
      end

      it 'does not delete the queued_video if current user doesnt own the it' do
        other_user = Fabricate(:user)
        queue = Fabricate(:queued_video, user: other_user)
        delete :destroy, id: queue.id
        expect(QueuedVideo.count).to eq(1)
      end

      it 'normalizes the remaining queued_videos' do
        queue1 = Fabricate(:queued_video, user: user, order: 1)
        queue2 = Fabricate(:queued_video, user: user, order: 2)
        queue3 = Fabricate(:queued_video, user: user, order: 3)

        delete :destroy, id: queue1.id
        expect(user.queued_videos.map(&:order)).to eq([1,2])
      end

      it 'redirects to queued_videos_path' do
        queue = Fabricate(:queued_video, user: user)
        delete :destroy, id: queue.id
        expect(response).to redirect_to(queued_videos_path)
      end
    end

    it 'redirects to login_path in not authenticated' do
        queue = Fabricate(:queued_video)
        delete :destroy, id: queue.id
        expect(response).to redirect_to(login_path)
    end
  end

  describe 'POST update' do
    context 'with authentication' do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
      end

      context 'with valid inputs' do
        let(:review) { Fabricate(:review, user: user, rating: 3) }
        let(:vid) { Fabricate(:video, reviews: []) }
        let(:reviewed_vid1) { Fabricate(:video, reviews: [review]) }
        let(:reviewed_vid2) { Fabricate(:video, reviews: [review]) }
        let(:queue1) { Fabricate(:queued_video, user: user, order: 1, video: vid) }
        let(:queue2) { Fabricate(:queued_video, user: user, order: 2, video: reviewed_vid1) }
        let(:queue3) { Fabricate(:queued_video, user: user, order: 3, video: reviewed_vid2) }

        it 'changes the queued videos orders based on the given params' do
          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 3},
                                        {id: queue2.id, order: 3, rating: 3},
                                        {id: queue3.id, order: 1, rating: 3}]
          expect(user.queued_videos).to eq([queue3, queue1, queue2])
        end

        it 'normalizes the orders to 1' do
          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 3},
                                        {id: queue2.id, order: 7, rating: 3},
                                        {id: queue3.id, order: 1, rating: 3}]
          expect(user.queued_videos.map(&:order)).to eq([1,2,3])
        end

        it 'creates a new review if a rating is supplied for video without a review' do
          post :update, queued_videos: [{id: queue1.id, order: 1, rating: 1}]
          expect(queue1.video.reviews.count).to eq(1)
          expect(queue1.rating).to eq(1)
        end

        it 'changes the reviews based on the given params if the videos have reviews' do
          post :update, queued_videos: [{id: queue2.id, order: 1, rating: 1},
                                        {id: queue3.id, order: 5, rating: 5}]
          expect(queue2.rating).to eq(1)
          expect(queue3.rating).to eq(5)
        end

        it 'redirects to queued_videos_path' do
          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 3},
                                        {id: queue2.id, order: 3, rating: 3},
                                        {id: queue3.id, order: 1, rating: 3}]
          expect(response).to redirect_to(queued_videos_path)
        end
      end

      context 'with invalid inputs' do
        let(:queue1) { Fabricate(:queued_video, user: user, order: 1) }
        let(:queue2) { Fabricate(:queued_video, user: user, order: 2) }
        let(:queue3) { Fabricate(:queued_video, user: user, order: 3) }

        before do
          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 3},
                                        {id: queue2.id, order: 3.5, rating: 3},
                                        {id: queue3.id, order: 4, rating: 3}]
        end

        it 'does not reorder any of the videos' do
          expect(user.queued_videos).to eq([queue1, queue2, queue3])
        end

        it 'sets the flash danger notice' do
          expect(flash[:danger]).to be_present
        end

        it 'redirects to the queued_videos_path' do
          expect(response).to redirect_to(queued_videos_path)
        end
      end

      context 'with queued videos that dont belong to the current_user' do
        it 'redirects to queued_videos_path' do
          post :update
          expect(response).to redirect_to(queued_videos_path)
        end

        it 'does not change the queued_videos' do
          other_user = Fabricate(:user)
          queue1 = Fabricate(:queued_video, user: user, order: 1)
          queue2 = Fabricate(:queued_video, user: other_user, order: 2)
          queue3 = Fabricate(:queued_video, user: user, order: 2)

          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 3},
                                        {id: queue2.id, order: 1, rating: 3},
                                        {id: queue3.id, order: 1, rating: 3}]
          expect(queue1.reload.order).to eq(1)
        end

        it 'does not change the reviews' do
          other_user = Fabricate(:user)
          review = Fabricate(:review, rating: 3, user: other_user)
          reviewed_vid = Fabricate(:video, reviews: [review])
          queue1 = Fabricate(:queued_video, video: reviewed_vid, user: other_user)
          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 1}]
          expect(queue1.rating).to eq(3)
        end

        it 'does not create any reviews' do
          reviewed_vid = Fabricate(:video, reviews: [])
          queue1 = Fabricate(:queued_video, video: reviewed_vid)
          post :update, queued_videos: [{id: queue1.id, order: 2, rating: 1}]
          expect(Review.all.count).to eq(0)
        end
      end
    end

    it 'redirects to login_path if not authenticated' do
      post :update
      expect(response).to redirect_to(login_path)
    end

    it 'does not reorder the videos if not authenticated' do
        queue1 = Fabricate(:queued_video, order: 1)
        queue2 = Fabricate(:queued_video, order: 2)
        post :update, queued_videos: [{id: queue1.id, order: 2, rating: 3},
                                      {id: queue2.id, order: 1, rating: 3}]
        expect(QueuedVideo.all).to eq([queue1, queue2])
    end
  end

end
