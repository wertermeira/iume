Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, default: { format: :json } do
    namespace :owners do
      resources :sessions, only: %i[create destroy]
      resources :restaurants, only: %i[index create update show] do
        resources :sections, module: :restaurants
      end
    end
    resources :owners, only: %i[create update show]
    resources :recover_password, path: 'recover_password/:model', only: %i[create update]
  end
end
