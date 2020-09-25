require 'rails_helper'

RSpec.describe OwnerRemarketingJob, type: :job do
  let(:owner) { create(:owner) }
  it 'with queue' do
    expect {
      described_class.set(queue: 'default', retry: 3).perform_later(owner)
    }.to have_enqueued_job.on_queue('default').at(:no_wait)
  end

  it 'perform_now execute' do
    expect {
      described_class.perform_now(owner.id)
    }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
end
