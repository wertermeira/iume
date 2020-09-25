module V1
  class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :slug, :active, :products_remaining
    has_many :phones, serializer: V1::PhoneSerializer
    has_one :address, serializer: V1::AddressSerializer
    has_one :tool_whatsapp, serializer: V1::Tools::WhatsappSerializer

    def id
      object.uid
    end

    def products_remaining
      ENV.fetch('MAX_PRODUCTS', 15).to_i - object.products.count
    end
  end
end
