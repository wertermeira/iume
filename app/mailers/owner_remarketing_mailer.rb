class OwnerRemarketingMailer < ApplicationMailer
  def send_to_owner(owner)
    @owner = owner
    @summary = I18n.t('mailer.messages.complete_menu.summary')
    mail(to: owner.email, subject: I18n.t('mailer.messages.complete_menu.subject'))
  end
end
