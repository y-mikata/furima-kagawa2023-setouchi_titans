Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  root to: "items#index"
  resources :items do
    resources :orders, only: [:index, :create]
  end
  resources :users, only: :show do
    member do
      get 'likes'
      get 'items'
      get 'orders'
      get 'cards'
    end
  end
end
