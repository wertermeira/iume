require 'rails_helper'

module Test
  UsernameValidatable = Struct.new(:username) do
    include ActiveModel::Validations

    validates :username, username: true
  end
end

RSpec.describe UsernameValidator, type: :model do
  subject(:model) { Test::UsernameValidatable.new 'xxtestxx' }

  it { is_expected.to be_valid }

  it 'is invalid' do
    model.username = 'xx 2x/'
    model.valid?
    expect(model.errors[:username]).to match_array(I18n.t('errors.messages.username_invalid'))
  end
end
