class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, content)
    message = I18n.t('errors.messages.invalid_phone')
    record.errors[attribute] << (options[:message] || message) unless content.match?(/\A\d{2}-\d{4,5}-\d{4}\z/)
  end
end
