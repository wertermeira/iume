require 'correios-cep'
class CepValidator < ActiveModel::EachValidator
  CORREIOS_CEP_I18N_SCOPE = 'errors.messages.correios'.freeze
  def validate_each(record, attribute, content)
    match_cep = /^\d{5}-?\d{3}$/
    error_message_scope = begin
                            if content.match?(match_cep)
                              return if Correios::CEP::AddressFinder.get(content).present?
                            end

                            I18n.t("#{CORREIOS_CEP_I18N_SCOPE}.not_exists")
                          rescue EOFError
                            I18n.t("#{CORREIOS_CEP_I18N_SCOPE}.connection_failed")
                          rescue ArgumentError
                            I18n.t("#{CORREIOS_CEP_I18N_SCOPE}.invalid")
                          rescue Net::OpenTimeout
                            I18n.t("#{CORREIOS_CEP_I18N_SCOPE}.timeouted")
                          end

    record.errors.add(attribute, error_message_scope, zipcode: content) if error_message_scope.present?
  end
end
