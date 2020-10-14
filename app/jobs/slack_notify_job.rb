class SlackNotifyJob < ApplicationJob
  queue_as :default

  def perform(message:, channel:)
    notifier = Slack::Notifier.new(webhook, channel: channel, username: 'iume-boy-bot')
    notifier.ping(message)
  end

  private

  def webhook
    Rails.application.config.slack_webhook
  end
end
