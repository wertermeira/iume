require 'rails_helper'

RSpec.describe Section, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[restaurant_id name position active].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when associations' do
    subject { create(:section) }

    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

  describe 'when validation' do
    subject { create(:restaurant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(200) }
  end

  context 'whens scope' do
    it 'sort_by_position' do
      expect(described_class.sort_by_position.to_sql).to eq(described_class.order(position: :asc).to_sql)
    end
  end
end
