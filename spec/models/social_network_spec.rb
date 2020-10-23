require 'rails_helper'

RSpec.describe SocialNetwork, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[restaurant_id provider restaurant_id].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when associations' do
    it { is_expected.to belong_to(:restaurant) }
  end

  describe 'when validation' do
    subject { create(:social_network) }
    let(:provider) { { facebook: 0, instagram: 1 } }

    it { is_expected.to define_enum_for(:provider).with_values(provider) }
    it { is_expected.to allow_value('xx22.xx2').for(:username) }
    it { is_expected.not_to allow_value('Xx1/').for(:username) }

    it { is_expected.to validate_length_of(:username).is_at_most(200) }
    it { is_expected.to validate_uniqueness_of(:restaurant_id).scoped_to(:provider) }
  end
end
