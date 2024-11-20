Rails.application.routes.draw do
  root "home#index"

  get 'signup', to: 'users#new'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  get 'logout', to: 'user_sessions#destroy'

  resources :users, only: [:new, :create]
end
