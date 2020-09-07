require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[section_id name description active position].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have association' do
    it { is_expected.to belong_to(:section) }
  end

  describe 'when validation' do
    let(:section) { create(:section) }
    let(:max_products) { ENV.fetch('MAX_PRODUCT_SECTION', 50) }
    let(:product_new) {
      described_class.new(
        name: Faker::Name.name, price: 10, section: section
      )
    }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_length_of(:name).is_at_most(200) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
    it { is_expected.to validate_numericality_of(:price) }

    context 'when image' do
      let(:types_allow) { %w[image/png image/gif image/jpg image/jpeg] }

      it { is_expected.to validate_size_of(:image).less_than(4.megabytes) }
      it { is_expected.to validate_content_type_of(:image).allowing(types_allow) }
      it { is_expected.not_to validate_content_type_of(:image).allowing(%w[image/tif doc/pdf]) }
    end

    context 'when max products per section' do
      it 'invalid' do
        create_list(:product, max_products, section: section)
        expect(product_new).not_to be_valid
      end

      it 'valid' do
        create_list(:product, max_products - 1, section: section)
        expect(product_new).to be_valid
      end

      it 'message error' do
        create_list(:product, max_products, section: section)
        product_new.valid?
        expect(product_new.errors[:section_id]).to match_array([I18n.t('errors.messagens.less_than_or_equal_to', count: max_products)])
      end
    end
  end
end
