require 'rails_helper'

RSpec.describe City, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[state_id name].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:state) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
  end
end
