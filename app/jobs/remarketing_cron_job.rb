class RemarketingCronJob < ApplicationJob
  queue_as :default

  def perform
    Owner.remarketings.all.pluck(:id).map { |id| OwnerRemarketingJob.perform_later(id) }
  end
end
