require 'rails_helper'

RSpec.describe OwnerPasswordValidation, type: :model do
  describe '#check_password' do
    let(:password) { Faker::Internet.password(min_length: 8, max_length: 12) }
    let(:owner) { create(:owner, password: password, password_confirmation: password) }

    it 'when password_current is valid' do
      described = described_class.new(password: 'xxxxxxx', password_current: password, current_user: owner)
      expect(described).to be_valid
    end

    it 'when password_current is valid (update only email)' do
      described = described_class.new(email: 'email@site.com', password_current: password, current_user: owner)
      expect(described).to be_valid
    end

    it 'when password blank is valid' do
      described = described_class.new(password: '', password_current: '', current_user: owner)
      expect(described).to be_valid
    end

    it 'when password_current is blank' do
      described = described_class.new(password: 'xxxxxxx', password_current: '', current_user: owner)
      expect(described).not_to be_valid
    end

    it 'when password_current is invalid' do
      described = described_class.new(password: 'xxxxxxx', password_current: 'xxx', current_user: owner)
      described.valid?
      expect(described.errors[:password_current]).to match_array([I18n.t('errors.messages.login.invalid_password')])
    end
  end
end
