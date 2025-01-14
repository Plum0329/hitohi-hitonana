Rails.application.routes.draw do
  root 'home#index'
  
  get 'signup', to: 'users#new'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :posts do
    collection do
      get :new_type
      get :new_reading
      get :new_content
      get :confirm
    end
  end

  resources :image_posts do
    collection do
      post :confirm
      get :complete
    end
  end
  
  resource :profile, only: [:show, :edit, :update] do
    get 'password', to: 'profiles#edit_password'
    patch 'password', to: 'profiles#update_password'
  end

  resource :registration, only: [] do
    delete 'deactivate', to: 'registrations#deactivate'
  end
end