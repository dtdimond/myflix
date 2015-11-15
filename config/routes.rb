Myflix::Application.routes.draw do
  root to: 'pages#front'
  get '/home', to: 'videos#index'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end

    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]

  resources :queued_videos, only: [:index, :create, :destroy]
  post '/queued_videos/update', to: 'queued_videos#update'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  get '/register', to: 'users#new'
  resources :users, only: [:create, :show]

  get '/people', to: 'followings#index', as: 'followings'
  post '/followings', to: 'followings#create', as: 'create_following'
  resources :followings, only: [:destroy]

  get 'ui(/:action)', controller: 'ui'
end
