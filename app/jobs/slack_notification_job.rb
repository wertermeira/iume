class SlackNotificationJob < ApplicationJob
  sidekiq_options retry: 3,
                  queue_as: 'default'

  def perform(message:, channel:)
    notifier = Slack::Notifier.new(ENV['WEBHOOK_SLACK'], channel: channel, username: 'notifier')
    notifier.ping(Slack::Notifier::Util::LinkFormatter.format(message))
  end
end
