Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, default: { format: :json } do
    namespace :owners do
      resources :sessions, only: %i[create destroy]
    end
    resources :owners, only: %i[create update show]
  end
end
