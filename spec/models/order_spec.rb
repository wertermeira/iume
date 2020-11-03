require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'when db schema uid' do
    let(:model) { described_class.column_names }

    %w[restaurant_id].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:order_details).dependent(:destroy) }

    it { is_expected.to accept_nested_attributes_for(:order_details) }
  end

  context 'when validation' do
    it { is_expected.to validate_presence_of(:order_details).on(:endpoint) }
  end

  describe 'when validate tool_whatsapp' do
    let(:new_order) { described_class.new(restaurant: restaurant) }

    context 'when order is valid' do
      let(:restaurant) { create(:restaurant_with_tool_whatsapp) }
      it { expect(new_order).to be_valid }
    end

    context 'when order is invalid' do
      let(:restaurant) { create(:restaurant_with_tool_whatsapp, whatsapp_active: false) }

      it do
        new_order.valid?
        expect(new_order.errors[:restaurant]).to match_array([I18n.t('errors.messages.tools_whatsapp_required')])
      end
    end
  end
end
