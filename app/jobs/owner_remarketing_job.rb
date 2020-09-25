class OwnerRemarketingJob < ApplicationJob
  sidekiq_options retry: 3,
                  queue_as: 'default'

  def perform(id)
    owner = Owner.find_by(id: id)

    return if owner.blank?

    owner.increment!(:remarketing)
    OwnerRemarketingMailer.send_to_owner(owner).deliver_later!
  end
end
