redis_url = ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' }

module RedisClient
  class << self
    def redis
      @redis ||= Redis.new(url: redis_url)
    end
  end
end

sidekiq_config = { url: redis_url }

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

# Setup sidekiq-cron
Sidekiq.configure_server do |config|
  schedule_file = "config/schedule.yml"

  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end
