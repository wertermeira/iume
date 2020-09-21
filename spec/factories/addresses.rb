FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.street_name }
    complement { Faker::Address.community }
    number { Faker::Address.building_number }
    reference { Faker::Address.city_prefix }
    cep { '44900-000' }
    addressable { create(:restaurant) }

    before :create do
      city = create(:city)
      response = {
        neighborhood: '',
        zipcode: '44900000',
        city: city.name,
        address: '',
        state: city.state.acronym,
        complement: ''
      }
      correios = instance_double(Correios::CEP::AddressFinder)
      allow(Correios::CEP::AddressFinder).to receive(:new).and_return(correios)
      allow(correios).to receive(:get).and_return(response)
    end
  end
end
