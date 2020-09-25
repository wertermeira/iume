require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[order_id quantity unit_price quantity].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'when validation' do
    let(:order_detail) { create(:order_detail) }
    it { is_expected.to validate_presence_of(:quantity) }

    it 'price' do
      expect(order_detail.unit_price).to eq(order_detail.product.price)
    end

    context 'when validate products' do
      let(:order) { create(:order) }
      let(:section) { create(:section, restaurant: order.restaurant) }
      let(:attributes) {
        {
          order: order,
          product: create(:product, section: section),
          quantity: 1
        }
      }
      let(:new_order_detail) { described_class.new(attributes) }

      it 'valid' do
        expect(new_order_detail).to be_valid
      end

      it 'invalid' do
        attributes[:product] = create(:product)
        new_order_detail.valid?
        expect(new_order_detail.errors[:product_id]).to match_array([I18n.t('errors.messages.invalid')])
      end
    end
  end
end
