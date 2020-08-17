require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[section_id name description active position].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have association' do
    it { is_expected.to belong_to(:section) }
  end

  describe 'when validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_length_of(:name).is_at_most(200) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
    it { is_expected.to validate_numericality_of(:price) }

    context 'when image' do
      let(:types_allow) { %w[image/png image/gif image/jpg image/jpeg] }

      it { is_expected.to validate_size_of(:image).less_than(4.megabytes) }
      it { is_expected.to validate_content_type_of(:image).allowing(types_allow) }
      it { is_expected.not_to validate_content_type_of(:image).allowing(%w[image/tif doc/pdf]) }
    end
  end
end
