require 'rails_helper'

RSpec.describe Owner, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[name provider email account_status password_digest].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  it { is_expected.to have_secure_password }

  context 'when have associations' do
  end

  describe 'when validation' do
    subject { create(:owner) }
    let(:status) { { pending: 0, verified: 1, blocked: 2 } }

    it { is_expected.to define_enum_for(:account_status).with_values(status).with_prefix(:account) }

    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(200) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(20) }
    it { is_expected.to allow_value('owner@site.com').for(:email) }
    it { is_expected.not_to allow_value('owner@site').for(:email) }
    it { is_expected.to validate_confirmation_of(:password) }
    %i[name email].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end

    context 'when validation password' do
      subject { described_class.new(password: '') }

      it { is_expected.to validate_presence_of(:password).on(%i[create update_passoword]) }
    end
  end
end
