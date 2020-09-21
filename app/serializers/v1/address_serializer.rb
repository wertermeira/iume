module V1
  class AddressSerializer < ActiveModel::Serializer
    attributes :id, :street, :neighborhood, :complement,
               :reference, :number, :cep, :created_at, :updated_at
    has_one :city, serializer: V1::CitySerializer
  end
end
