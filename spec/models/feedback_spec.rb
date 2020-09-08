require 'rails_helper'

RSpec.describe Feedback, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[owner_id screen body].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:owner) }
  end

  context 'when validation' do
    it { is_expected.to validate_length_of(:screen).is_at_most(200) }
    it { is_expected.to validate_length_of(:body).is_at_most(1000) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
