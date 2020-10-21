module V1
  class RestaurantSerializer < V1::BaseSerializer
    attributes :id, :name, :slug, :active, :products_remaining, :image
    has_many :phones, serializer: V1::PhoneSerializer
    has_many :social_networks, serializer: V1::SocialNetworkSerializer
    has_one :address, serializer: V1::AddressSerializer
    has_one :tool_whatsapp, serializer: V1::Tools::WhatsappSerializer
    has_one :theme_color, serializer: V1::ThemeColorSerializer

    def id
      object.uid
    end

    def products_remaining
      ENV.fetch('MAX_PRODUCTS', 15).to_i - object.products.count
    end
  end
end
