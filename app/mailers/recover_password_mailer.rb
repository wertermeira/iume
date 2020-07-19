class RecoverPasswordMailer < ApplicationMailer
  def send_to_user(user:, token:)
    @user = user
    @token = token
    mail(to: user.email, subject: I18n.t('mailer.messages.reset_password'))
  end
end
