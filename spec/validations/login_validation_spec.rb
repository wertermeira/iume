require 'rails_helper'

RSpec.describe LoginValidation, type: :model do
  context 'when simple validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to allow_value('user@site.com').for(:email) }
    it { is_expected.not_to allow_value('user@site').for(:email) }
  end

  describe '#owner_exists' do
    let(:owner) { create(:owner) }

    it 'when email is found' do
      described = described_class.new(email: owner.email, password: 'xxxxxxx', model: Owner)
      expect(described).to be_valid
    end

    it 'when email is not found' do
      described = described_class.new(email: 'email_xx@xx.com', password: 'xxxxxxx', model: Owner)
      expect(described).not_to be_valid
    end

    it 'when email retorn error message' do
      described = described_class.new(email: 'email_xx@xx.com', password: 'xxxxxxx', model: Owner)
      described.valid?
      expect(described.errors[:email]).to match_array([I18n.t('errors.messages.email_not_found')])
    end
  end
end
