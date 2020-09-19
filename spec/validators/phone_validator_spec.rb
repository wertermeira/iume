require 'rails_helper'

module Test
  PhoneValidatable = Struct.new(:number_phone) do
    include ActiveModel::Validations

    validates :number_phone, phone: true
  end
end

RSpec.describe PhoneValidator, type: :model do
  subject(:model) { Test::PhoneValidatable.new '11-99999-0000' }

  it { is_expected.to be_valid }

  it 'number with 8 digit' do
    model.number_phone = '11-9999-9999'
    expect(model).to be_valid
  end

  it 'is invalid' do
    model.number_phone = '13-222-23'
    model.valid?
    expect(model.errors[:number_phone]).to match_array(I18n.t('errors.messages.invalid_phone'))
  end
end
