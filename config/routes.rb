Rails.application.routes.draw do

  get "/signin", to: "users#signin"
  get "/signout", to: "users#signout"
  get "/auth", to: redirect("/")
  post "/auth", to: "users#auth"

  get "/search", to: "articles#search"

  resources :users

  resources :articles do
    collection do
      get "autocomplete"
      get "ra_plugins/:template", action: :ra_plugins
    end
  end
  resources :photos do
    collection do
      get "fetch"
      get "search"
    end
    member do
      get "crop"
      get "mosaic"
    end
  end
  resources :embeds do
    collection do
      get "search"
    end
  end

	root "main#index"

end
