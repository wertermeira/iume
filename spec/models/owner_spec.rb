require 'rails_helper'

RSpec.describe Owner, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[name provider email account_status password_digest lock_version login_count].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  it { is_expected.to have_secure_password }

  context 'when have associations' do
    it { is_expected.to have_many(:restaurants).dependent(:destroy) }
    it { is_expected.to have_many(:sections).through(:restaurants) }
    it { is_expected.to have_many(:products).through(:sections) }
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
    it { is_expected.to validate_presence_of(:email) }

    context 'when validation password' do
      subject { described_class.new(password: '') }

      it { is_expected.to validate_presence_of(:password).on(%i[create update_passoword]) }
    end
  end

  context 'when remarketings' do
    let(:owner_count) { rand(1..10) }
    let!(:remarketing_0) { create_list(:owner, owner_count) }
    let!(:remarketing_1) { create_list(:owner, owner_count, remarketing: 1) }
    let!(:remarketing_2) { create_list(:owner, owner_count, remarketing: 2) }

    before do
      create_list(:owner_with_products, owner_count)
    end

    it 'before 1 day' do
      expect(described_class.remarketings.count).to eq(0)
    end

    it 'all' do
      expect(described_class.count).to eq(owner_count * 4)
    end

    it 'after 3 days' do
      travel(3.days + 1.minute) do
        expect(described_class.remarketings.all).to match_array(remarketing_0 + remarketing_1)
      end
      travel_back
    end

    it 'after 2 days' do
      travel(3.days - 1.minute) do
        expect(described_class.remarketings.all).to match_array(remarketing_0)
      end
      travel_back
    end
  end
end
