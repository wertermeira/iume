source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'
# A simple wrapper for posting to slack channels
gem "slack-notifier"
# Find Brazilian addresses by zipcode, directly from Correios database. No HTML parsers.\
gem 'correios-cep'
# ActiveModel::Serializer implementation and Rails hooks
gem 'active_model_serializers', '~> 0.10.0'
# FriendlyId is the 'Swiss Army bulldozer' of slugging and permalink plugins for
gem 'friendly_id', '~> 5.3.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# storage base and validtions
gem 'active_storage_base64'
gem 'active_storage_validations'
# The official AWS SDK for Ruby.
gem 'aws-sdk-s3', require: false

# new relic
gem 'newrelic_rpm'
# redis cache memory
gem 'redis', '~> 4.0'
# The authorization Gem for Ruby on Rails.
gem 'cancancan'
# Simple, efficient background processing for Ruby
gem 'sidekiq', '6.0.4'
gem 'sidekiq-cron', '~> 1.1'
# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'rswag-api'
gem 'rswag-ui'

gem 'database_url'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'brakeman'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fasterer'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rails_config', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubycritic', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Ruby on Rails 3/4/5 model and controller UML class diagram generator.
  gem 'railroady'
end

group :test do
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'

  gem 'webmock'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
