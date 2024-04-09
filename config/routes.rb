Rails.application.routes.draw do
  get 'cards/new'
  get 'users/show'
  devise_for :users
  root to: "items#index"
  post 'toggle_card_list', to: 'orders#toggle_card_list'
  resources :items do
    resources :orders, only: [:index, :create] do
      collection do
        get 'refresh_card_frame'
        post 'set_card'
        post 'clear_session'
      end
    end
  end
  resources :users, only: :show do
    resources :cards, only: [:index, :new, :create, :destroy] do
      member do
        post 'set_default'
      end
    end
    member do
      get 'likes'
      get 'items'
      get 'orders'
    end
  end
end
