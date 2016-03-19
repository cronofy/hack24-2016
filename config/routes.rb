Rails.application.routes.draw do
  root "root#index"

  delete '/', to: 'root#destroy'

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  get 'logout', to: "sessions#logout"

  get 'ui', to: "root#ui"

  resource :session, only: [:create, :destroy]
  resources :channels, only: [:show]
  resources :weights, only: [:index]
end
