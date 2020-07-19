require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[owner_id name slug].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when associations' do
    it { is_expected.to belong_to(:owner) }
  end

  describe 'when validation' do
    subject { create(:restaurant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(200) }
    it { is_expected.to allow_value('xx22xx2').for(:slug) }
    it { is_expected.not_to allow_value('Xx1').for(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
