require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[owner_id name slug active].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when associations' do
    subject { create(:restaurant) }

    it { is_expected.to belong_to(:owner) }
    it { is_expected.to have_many(:sections).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:sections) }
    it { is_expected.to have_many(:phones).dependent(:destroy) }
    it { is_expected.to have_one(:address).dependent(:destroy) }

    it 'accept_nested_attributes_for phones' do
      expect(subject).to accept_nested_attributes_for(:phones).limit(4).allow_destroy(true).update_only(true)
    end

    it 'accept_nested_attributes_for address' do
      expect(subject).to accept_nested_attributes_for(:address).allow_destroy(false).update_only(true)
    end
  end

  describe 'when validation' do
    subject { create(:restaurant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(200) }
    it { is_expected.to validate_length_of(:slug).is_at_least(3).is_at_most(200) }
    it { is_expected.to allow_value('xx22-xx2').for(:slug) }
    it { is_expected.not_to allow_value('Xx1').for(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
