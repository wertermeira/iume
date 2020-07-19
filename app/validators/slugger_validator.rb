class SluggerValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, content)
    regex_name = /^[a-z-0-9_(-)]+$/
    message = I18n.t('errors.messages.slugger_invalid')
    record.errors[attribute] << (options[:message] || message) unless content.match?(regex_name)
  end
end
