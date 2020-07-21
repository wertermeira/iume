require 'sidekiq/web'
Rails.application.routes.draw do
  namespace :v1, default: { format: :json } do
    namespace :owners do
      resources :sessions, only: %i[create destroy]
      resources :restaurants, only: %i[index create update show] do
        resources :sections, module: :restaurants do
          collection do
            put 'sort', to: 'sections#sort'
          end
        end
      end
    end
    resources :owners, only: %i[create update show] do
      get 'emails', to: 'owners/emails#show', on: :collection
    end
    resources :recover_password, path: 'recover_password/:model', only: %i[create update]
  end
  mount Sidekiq::Web => 'sidekiq'
end
