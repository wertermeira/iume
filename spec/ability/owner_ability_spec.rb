require 'cancan/matchers'
require 'rails_helper'

RSpec.describe OwnerAbility, type: :model do
  subject(:ability) { described_class.new(owner) }

  context 'when owner' do
    let(:owner) { create(:owner) }
    let(:other_owner) { create(:owner) }

    it { is_expected.to be_able_to(:manage, Section.new(restaurant: create(:restaurant, owner: owner))) }
    it { is_expected.to be_able_to(:manage, Restaurant.new(owner: owner)) }

    it { is_expected.not_to be_able_to(:manage, Restaurant.new(owner: other_owner)) }
    it { is_expected.not_to be_able_to(:manage, Section.new(restaurant: create(:restaurant, owner: other_owner))) }
  end
end
