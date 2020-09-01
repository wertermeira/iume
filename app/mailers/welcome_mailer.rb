class WelcomeMailer < ApplicationMailer
  def send_to_owner(owner)
    @owner = owner
    @summary = I18n.t('mailer.messages.welcome.summary')
    mail(to: owner.email, subject: I18n.t('mailer.messages.welcome.subject'))
  end
end
