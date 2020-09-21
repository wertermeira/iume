require 'rails_helper'

RSpec.describe Region, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    it { expect(model).to include('name') }
  end

  context 'when have associations' do
    it { is_expected.to have_many(:states).dependent(:destroy) }
  end
end
