require 'rails_helper'

RSpec.describe Scheduled::RemarketingJob, type: :job do
  let(:owner_count) { rand(1..10) }
  let!(:remarketing_0) { create_list(:owner, owner_count) }
  let!(:remarketing_1) { create_list(:owner, owner_count, remarketing: 1) }
  let!(:remarketing_2) { create_list(:owner, owner_count, remarketing: 2) }

  it 'with queue' do
    expect {
      described_class.set(queue: 'default', retry: 3).perform_later
    }.to have_enqueued_job.on_queue('default').at(:no_wait)
  end

  it 'perform_now execute after 1 day' do
    travel(1.days + 1.minute) do
      expect {
        described_class.perform_now
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(owner_count)
    end
    travel_back
  end

  it 'perform_now execute first day' do
    expect {
      described_class.perform_now
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(0)
  end

  it 'perform_now execute after 3 day' do
    travel(3.days + 1.minute) do
      expect {
        described_class.perform_now
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(owner_count * 2)
    end
    travel_back
  end
end
