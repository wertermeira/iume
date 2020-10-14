require 'rails_helper'

RSpec.describe ThemeColor, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[color].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end
end
