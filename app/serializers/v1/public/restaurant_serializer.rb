module V1
  module Public
    class RestaurantSerializer < V1::BaseSerializer
      attributes :id, :name, :slug, :active, :image
      has_many :sections, serializer: V1::Public::SectionSerializer
      has_many :phones, serializer: V1::PhoneSerializer
      has_many :social_networks, serializer: V1::SocialNetworkSerializer
      has_one :address, serializer: V1::Public::AddressSerializer
      has_one :tool_whatsapp, serializer: V1::Public::WhatsappSerializer
      has_one :theme_color, serializer: V1::ThemeColorSerializer

      def sections
        if scope[:current_user].present? && scope[:current_user].restaurants.find_by(id: object.id)
          object.sections.where(active: true).sort_by_position
        elsif object.active
          object.sections.published.sort_by_position
        end
      end

      def id
        object.uid
      end
    end
  end
end
