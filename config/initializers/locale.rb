# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
 
# Permitted locales available for the application
I18n.available_locales = [:en, :'pt-BR']
 
# Set default locale to something other than :en
I18n.default_locale = :'pt-BR'

if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |exception, locale, key, options|
    raise "missing translation: #{key} in #{locale.to_s}"
  end
end