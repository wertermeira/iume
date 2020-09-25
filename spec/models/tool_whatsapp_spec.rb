require 'rails_helper'

RSpec.describe ToolWhatsapp, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[restaurant_id phone_id active].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to belong_to(:phone) }
  end

  describe 'when validation' do
    let(:restaurant) { create(:restaurant) }
    let(:phone) { create(:phone, phoneable: restaurant) }
    let(:attributes) {
      {
        restaurant: restaurant,
        phone: phone,
        active: false
      }
    }
    let(:new_whatsapp) { described_class.new(attributes) }

    it 'when valid phone' do
      expect(new_whatsapp).to be_valid
    end

    context 'when phone invalid' do
      let(:phone) { create(:phone) }

      it 'when valid phone' do
        new_whatsapp.valid?
        expect(new_whatsapp.errors[:phone_id]).to match_array([I18n.t('errors.messages.invalid')])
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

    context 'when active option is invalid' do
      before do
        attributes[:active] = true
      end
      it 'when valid phone' do
        new_whatsapp.valid?
        expect(new_whatsapp.errors[:active]).to match_array([I18n.t('errors.messages.tools_address_required')])
      end
    end
  end
end
