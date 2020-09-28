require 'rails_helper'

RSpec.describe Phone, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[phoneable_type phoneable_id number].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have associations' do
    it { is_expected.to belong_to(:phoneable) }
  end

  context 'when validation' do
    subject { described_class.create(phoneable: create(:restaurant)) }

    it { is_expected.to validate_uniqueness_of(:number).scoped_to(%i[phoneable_type phoneable_id]) }
    it { is_expected.to allow_value('11-99999-0000').for(:number) }
    it { is_expected.to allow_value('11-9999-0000').for(:number) }
    it { is_expected.not_to allow_value('11-9999-000000').for(:number) }
    it { is_expected.to validate_presence_of(:number) }
  end
end
