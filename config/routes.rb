require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.default_url_options[:host] = ENV.fetch('APP_URL') { 'localhost:3000' }
Rails.application.routes.draw do
  if ENV.fetch('API_DOCS_ENABLED', '').present?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
  namespace :v1, default: { format: :json } do
    namespace :owners do
      resources :theme_color, only: :index
      resources :feedbacks, only: :create
      resources :sessions, only: %i[create destroy]
      resources :restaurants, only: %i[index create update show] do
        put 'availability_slug', to: 'restaurants#availability_slug', on: :collection
        resources :sections, module: :restaurants do
          put 'sort', to: 'sections#sort', on: :collection
        end
        namespace :tools, module: 'restaurants/tools' do
          get 'whatsapp', to: 'whatsapp#index'
          match 'whatsapp', to: 'whatsapp#update', via: %i[put patch]
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
    resources :restaurants, only: :show do
      resources :orders, only: :create, module: :restaurants
    end
  end
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME', 'admin'))) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD', '123456')))
  end if Rails.env.production?
  mount Sidekiq::Web => 'sidekiq'
end
