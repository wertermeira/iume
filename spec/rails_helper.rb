# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
  include RSpec::Mocks::ExampleMethods
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.file_fixture_path =  "#{::Rails.root}/spec/support/fixtures"
  config.include ActiveJob::TestHelper, type: :job
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Custom json helpers
  config.include Requests::JsonHelpers, type: :request
  # Custom header helpers
  config.include Requests::HeaderHelpers, type: :request
  # Custom serializer helpers
  config.include Requests::SerializerHelpers, type: :request
  config.include Fixtures::ImageHelpers
end
