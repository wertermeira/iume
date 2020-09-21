require 'rails_helper'

RSpec.describe Address, type: :model do
  subject { create(:address) }

  context 'when db schema' do
    let(:model) { described_class.column_names }

    %w[street neighborhood
       city_id complement number
       reference cep addressable_type addressable_id].each do |column|
      it "have column #{column}" do
        expect(model).to include(column)
      end
    end
  end

  context 'when have association' do
    it { is_expected.to belong_to(:addressable) }
    it { is_expected.to belong_to(:city).optional }
  end

  describe 'when validation' do
    %i[street neighborhood cep].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
    %i[street neighborhood].each do |field|
      it { is_expected.to validate_length_of(field).is_at_most(200) }
    end

    context 'when validation cep' do
      let(:correios) { instance_double(Correios::CEP::AddressFinder) }
      let(:response) {
        {
          neighborhood: '',
          zipcode: '44900000',
          city: 'Irecê',
          address: '',
          state: 'BA',
          complement: ''
        }.to_json
      }

      before do
        allow(Correios::CEP::AddressFinder).to receive(:new).and_return(correios)
        allow(correios).to receive(:get).and_return(response)
      end

      it { is_expected.to allow_value('44900-000').for(:cep) }
      it { is_expected.not_to allow_value('000-000-000').for(:cep) }
    end
  end
end
