module V1
  module Public
    class RestaurantSerializer < ActiveModel::Serializer
      attributes :id, :name, :slug, :active
      has_many :sections, serializer: V1::Public::SectionSerializer
      has_many :phones, serializer: V1::PhoneSerializer
      has_one :address, serializer: V1::Public::AddressSerializer

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
