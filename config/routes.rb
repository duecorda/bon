Rails.application.routes.draw do

  get "/signin", to: "users#signin"
  get "/signout", to: "users#signout"
  get "/auth", to: redirect("/")
  post "/auth", to: "users#auth"

  resources :users

  resources :articles do
    collection do
      get "ra_plugins/:template", action: :ra_plugins
    end
  end
  resources :photos do
    collection do
      get "search"
    end
  end
  resources :embeds do
    collection do
      get "search"
    end
  end

	root "main#index"

end
