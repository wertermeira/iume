Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, default: { format: :json } do
    resources :users, only: %i[create update show]
  end
end
