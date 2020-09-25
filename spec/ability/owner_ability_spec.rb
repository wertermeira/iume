require 'cancan/matchers'
require 'rails_helper'

RSpec.describe OwnerAbility, type: :model do
  subject(:ability) { described_class.new(owner) }

  context 'when owner' do
    let(:owner) { create(:owner) }
    let(:other_owner) { create(:owner) }
    let(:restaurant) { create(:restaurant, owner: owner) }
    let(:section) { create(:section, restaurant: restaurant) }

    it { is_expected.to be_able_to(:manage, Section.new(restaurant: restaurant)) }
    it { is_expected.to be_able_to(:manage, Restaurant.new(owner: owner)) }
    it { is_expected.to be_able_to(:manage, Product.new(section: section)) }
    it { is_expected.to be_able_to(:manage, ToolWhatsapp.new(restaurant: restaurant)) }

    it { is_expected.not_to be_able_to(:manage, Restaurant.new(owner: other_owner)) }
    it { is_expected.not_to be_able_to(:manage, Section.new(restaurant: create(:restaurant))) }
    it { is_expected.not_to be_able_to(:manage, Product.new(section: create(:section))) }
    it { is_expected.not_to be_able_to(:manage, ToolWhatsapp.new(restaurant: create(:restaurant))) }
  end
end
