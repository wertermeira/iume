class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, content)
    regex_email = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    message = I18n.t('errors.messages.invalid_email_address')
    record.errors[attribute] << (options[:message] || message) unless content.match?(regex_email)
  end
end
