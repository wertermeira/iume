require 'rails_helper'

RSpec.describe State, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[name region_id].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:region) }
    it { is_expected.to have_many(:cities).dependent(:destroy) }
  end
end
