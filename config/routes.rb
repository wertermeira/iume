Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1, default: { format: :json } do
    namespace :owners do
      resources :restaurants, only: %i[index create update show] do
        resources :sections, module: :restaurants do
          collection do
            put 'sort', to: 'sections#sort'
          end
        end
      end
      namespace :restaurants, path: 'restaurants/sections/:section_id' do
        resources :products, controller: 'sections/products'
      end
    end
    resources :owners, only: %i[create update show]
    resources :recover_password, path: 'recover_password/:model', only: %i[create update]
  end
end
