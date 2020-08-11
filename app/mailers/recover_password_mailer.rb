class RecoverPasswordMailer < ApplicationMailer
  def send_to_owner(owner:, token:)
    @owner = owner
    @token = token
    mail(to: owner.email, subject: I18n.t('mailer.messages.reset_password'))
  end
end
