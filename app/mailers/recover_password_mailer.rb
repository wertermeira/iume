class RecoverPasswordMailer < ApplicationMailer
  def send_to_owner(owner:, token:)
    @owner = owner
    @token = token
    @summary = I18n.t('mailer.messages.reset_password.summary')
    mail(to: owner.email, subject: I18n.t('mailer.messages.reset_password.subject'))
  end
end
