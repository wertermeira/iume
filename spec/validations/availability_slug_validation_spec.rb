require 'rails_helper'

RSpec.describe AvailabilitySlugValidation, type: :model do
  context 'when simple validations' do
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to allow_value('xx22-xx2').for(:slug) }
    it { is_expected.not_to allow_value('Xx1').for(:slug) }
  end

  describe '#availability_restaurant' do
    let(:restaurant_name) { 'restaurantname' }

    before { create(:restaurant, name: restaurant_name) }

    it 'when restaurant slug availabilty' do
      described = described_class.new(slug: 'other_restaurantname')
      expect(described).to be_valid
    end

    it 'when restaurant slug unavailable' do
      described = described_class.new(slug: restaurant_name)
      expect(described).not_to be_valid
    end
  end
end
