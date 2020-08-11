require 'sidekiq/web'
Rails.application.routes.default_url_options[:host] = ENV.fetch('APP_URL') { 'localhost:3000' }
Rails.application.routes.draw do
  namespace :v1, default: { format: :json } do
    namespace :owners do
      resources :feedbacks, only: :create
      resources :sessions, only: %i[create destroy]
      resources :restaurants, only: %i[index create update show] do
        resources :sections, module: :restaurants do
          put 'sort', to: 'sections#sort', on: :collection
        end
      end
      namespace :restaurants, path: 'restaurants/sections/:section_id' do
        resources :products, controller: 'sections/products' do
          put 'sort', to: 'sections/products#sort', on: :collection
        end
      end
    end
    resources :owners, only: %i[create update show destroy] do
      get 'emails', to: 'owners/emails#show', on: :collection
    end
    resources :recover_password, path: 'recover_password/:model', only: %i[create update]
    resources :products, controller: 'restaurants/sections/products', only: %i[index show], path: 'restaurants/sections/:section_id/products'
    resources :restaurants, only: :show
  end
  mount Sidekiq::Web => 'sidekiq'
end
