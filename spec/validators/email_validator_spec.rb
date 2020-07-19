require 'rails_helper'

module Test
  EmailValidatable = Struct.new(:email) do
    include ActiveModel::Validations

    validates :email, email: true
  end
end

RSpec.describe EmailValidator, type: :model do
  subject(:model) { Test::EmailValidatable.new 'test@mail.de' }

  it { is_expected.to be_valid }

  it 'is invalid' do
    model.email = 'mail.de'
    model.valid?
    expect(model.errors[:email]).to match_array(I18n.t('errors.messages.invalid_email_address'))
  end
end
