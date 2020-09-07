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
    subject { create(:section) }
    let(:max_sections) { ENV.fetch('MAX_SECTION_RESTAURANT', 50) }
    let(:restaurant) { create(:restaurant) }
    let(:section_new) { described_class.new(name: Faker::Name.name, restaurant: restaurant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(200) }

    context 'when max section per restaurant' do
      it 'invalid' do
        create_list(:section, max_sections, restaurant: restaurant)
        expect(section_new).not_to be_valid
      end

      it 'valid' do
        create_list(:section, max_sections - 1, restaurant: restaurant)
        expect(section_new).to be_valid
      end

      it 'message error' do
        create_list(:section, max_sections, restaurant: restaurant)
        section_new.valid?
        expect(section_new.errors[:restaurant]).to match_array([I18n.t('errors.messagens.less_than_or_equal_to', count: max_sections)])
      end
    end
  end

  context 'whens scope' do
    it 'sort_by_position' do
      expect(described_class.sort_by_position.to_sql).to eq(described_class.order(position: :asc).to_sql)
    end
  end
end
