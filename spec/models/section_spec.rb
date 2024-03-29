require 'rails_helper'

RSpec.describe Section, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[restaurant_id name position active deleted].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when associations' do
    subject { create(:section) }

    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:products) }

    it 'has many unscope_products' do
      expect(subject).to have_many(:unscope_products).class_name('Product').inverse_of(:section).dependent(:nullify)
    end
  end

  describe 'when validation' do
    subject { create(:section) }
    let(:max_sections) { ENV.fetch('MAX_SECTION_RESTAURANT', 10) }
    let(:restaurant) { create(:restaurant) }
    let(:section_new) { described_class.new(name: Faker::Name.name, restaurant: restaurant) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(200) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }

    context 'when max section per restaurant' do
      let(:message) { I18n.t('errors.messages.limit_max_items', max: max_sections, item: 'seções') }

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
        expect(section_new.errors[:max_sections]).to match_array([message])
      end
    end
  end

  context 'whens scope' do
    let!(:section_active) { create(:section) }
    let!(:section_deleted) { create(:section, deleted: true) }

    it 'sort_by_position' do
      expect(described_class.sort_by_position.to_sql).to eq(described_class.order(position: :asc).to_sql)
    end

    it 'default scope deleted' do
      expect(described_class.all).to match_array([section_active])
    end

    it 'unarchive (unscope' do
      expect(described_class.in_the_trash.all).to match_array([section_deleted])
    end
  end
end
