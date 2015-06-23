Rails.application.routes.draw do

  get "/signin", to: "users#signin"
  get "/signout", to: "users#signout"
  get "/auth", to: redirect("/")
  post "/auth", to: "users#auth"

  resources :users

	root "main#index"

end
