class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, content)
    regex_name = /^[A-z0-9_\-\.]+$/
    message = I18n.t('errors.messages.username_invalid')
    record.errors[attribute] << (options[:message] || message) unless content.match?(regex_name)
  end
end
