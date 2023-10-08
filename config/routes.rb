Rails.application.routes.draw do
  # Api definition
  # Rails will automatically map the namespace to a directory matching the name
  # under the controllers folder, in our case the api/` directory.
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # We are going to list our resources here
      resources :users, only: [:show, :create, :update, :destroy]
      resources :tokens, only: [:create]
      resources :products
      resources :orders, only: [:index]
    end
  end

end
