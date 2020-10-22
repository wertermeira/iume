class SocialNetwork < ApplicationRecord
  belongs_to :restaurant

  enum provider: { facebook: 0, instagram: 1 }

  validates :restaurant_id, uniqueness: { scope: :provider }
  validates :username, :provider, presence: true
  validates :username, length: { maximum: 200 }, allow_blank: true

  after_create :notification_slack

  private

  def notification_slack
    message = "Olá! <#{ENV['FRONTEND_URL']}/qr/#{restaurant.uid}|#{restaurant.name}> "\
              "acabou de adicionar o #{provider} <https://#{provider}.com/#{username}|#{username}> :bowtie:"
    SlackNotifyJob.perform_later(message: message, channel: ENV.fetch('SLACK_NOTIFY_CHANNEL', '#iume-notifications'))
  end
end
