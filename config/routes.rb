Rails.application.routes.draw do
  root "root#index"

  delete '/', to: 'root#destroy'

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  get 'logout', to: "sessions#logout"

  resource :session, only: [:create, :destroy]
  resources :channels, only: [:show]
end
