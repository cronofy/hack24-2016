Rails.application.routes.draw do
  root "root#index"

  delete '/', to: 'root#destroy'

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  resource :session, only: [:create, :destroy]

end
