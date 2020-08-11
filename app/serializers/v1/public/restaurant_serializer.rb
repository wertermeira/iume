module V1
  module Public
    class RestaurantSerializer < ActiveModel::Serializer
      attributes :id, :slug, :active
      has_many :sections, serializer: V1::Public::SectionSerializer, if: -> { object.active }

      def sections
        object.sections.published
      end

      def id
        object.uid
      end
    end
  end
end
