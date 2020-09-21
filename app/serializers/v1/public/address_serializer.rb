module V1
  module Public
    class AddressSerializer < ActiveModel::Serializer
      attributes :street, :neighborhood, :complement,
                 :reference, :number, :cep
      has_one :city, serializer: V1::CitySerializer
    end
  end
end
