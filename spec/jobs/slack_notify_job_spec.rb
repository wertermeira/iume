require 'rails_helper'

RSpec.describe SlackNotifyJob, type: :job do
  let(:message) { Faker::Restaurant.name }
  let(:channel) { '#slack' }
  it 'with queue' do
    expect {
      described_class.set(queue: 'default').perform_later(message: message, channel: channel)
    }.to have_enqueued_job.on_queue('default').at(:no_wait)
  end

  it 'perform_now execute' do
    webhook = 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'
    Rails.application.config.slack_webhook = webhook
    allow_any_instance_of(Slack::Notifier).to receive(:ping).and_return(message)
    expect(described_class.perform_now(message: message, channel: channel)).to eq(message)
  end
end
