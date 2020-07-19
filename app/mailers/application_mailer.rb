class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  default(
    from: "#{ENV['APP_NAME']} <#{ENV['EMAIL_SENDER']}>",
    reply_to: "No Reply: #{ENV['APP_NAME']} <#{ENV['EMAIL_SENDER']}>"
  )
end
