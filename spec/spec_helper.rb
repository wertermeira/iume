
require 'simplecov'
require 'webmock/rspec'
require 'active_storage_validations/matchers'

SimpleCov.start 'rails'
WebMock.allow_net_connect!
RSpec.configure do |config|
  config.include ActiveStorageValidations::Matchers
	config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/tmp/storage"])
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
