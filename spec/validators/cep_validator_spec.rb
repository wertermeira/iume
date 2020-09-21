require 'rails_helper'

module Test
  CepValidatable = Struct.new(:cep) do
    include ActiveModel::Validations

    validates :cep, cep: true
  end
end

RSpec.describe CepValidator, type: :model do
  subject(:model) { Test::CepValidatable.new }

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
  end

  it 'is valid' do
    allow(Correios::CEP::AddressFinder).to receive(:new).and_return(correios)
    allow(correios).to receive(:get).and_return(response)
    model.cep = '44900-000'
    expect(model).to be_valid
  end

  it 'is invalid and return error' do
    allow(Correios::CEP::AddressFinder).to receive(:new).and_return(correios)
    allow(correios).to receive(:get).and_return(nil)
    model.cep = '444-000-444'
    model.valid?
    expect(model.errors[:cep]).to match([I18n.t('errors.messages.correios.not_exists')])
  end

  context 'when raise errors' do
    it 'connection_failed' do
      allow(correios).to receive(:get).and_raise(EOFError)
      model.cep = '44900-000'
      model.valid?
      expect(model.errors[:cep]).to match([I18n.t('errors.messages.correios.connection_failed')])
    end

    it 'invalid' do
      allow(correios).to receive(:get).and_raise(ArgumentError)
      model.cep = '44900-000'
      model.valid?
      expect(model.errors[:cep]).to match([I18n.t('errors.messages.correios.invalid')])
    end

    it 'timeouted' do
      allow(correios).to receive(:get).and_raise(Net::OpenTimeout)
      model.cep = '44900-000'
      model.valid?
      expect(model.errors[:cep]).to match([I18n.t('errors.messages.correios.timeouted')])
    end
  end
end
