require 'rails_helper'

RSpec.describe ToolWhatsapp, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[restaurant_id active].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_one(:phone).dependent(:destroy) }
  end

  describe 'when validation' do
    let(:restaurant) { create(:restaurant) }
    let(:attributes) {
      {
        restaurant: restaurant,
        active: false,
        phone_attributes: {
          number: '11-9999-9999'
        }
      }
    }
    let(:new_whatsapp) { described_class.new(attributes) }

    it 'when valid phone' do
      expect(new_whatsapp).to be_valid
    end

    context 'when without number' do
      let(:attributes) {
        {
          restaurant: restaurant,
          active: false
        }
      }

      it do
        expect(new_whatsapp).not_to be_valid
      end
    end

    context 'when active option is valid' do
      before do
        attributes[:active] = true
        create(:address, addressable: restaurant)
      end
      it 'when valid phone' do
        expect(new_whatsapp).to be_valid
      end
    end
  end
end
