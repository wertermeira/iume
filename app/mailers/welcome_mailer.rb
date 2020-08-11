class WelcomeMailer < ApplicationMailer
  def send_to_owner(owner)
    @owner = owner
    mail(to: owner.email, subject: I18n.t('mailer.messages.welcome'))
  end
end
