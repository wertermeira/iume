class Feedback < ApplicationRecord
  belongs_to :owner

  validates :screen, length: { maximum: 200 }
  validates :body, length: { maximum: 1000 }, allow_blank: true
  validates :body, presence: true

  after_create :notification_slack

  private

  def notification_slack
    message = "Feedback enviado por <mailto:#{owner.email}|#{owner.email}> \n \n *#{body}*"
    SlackNotifyJob.perform_later(message: message, channel: ENV.fetch('SLACK_NOTIFY_CHANNEL', '#iume-notifications'))
  end
end
