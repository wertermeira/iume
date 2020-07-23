module V1
  module Public
    class RestaurantSerializer < ActiveModel::Serializer
      attributes :slug, :active
      has_many :sections, serializer: V1::Public::SectionSerializer, if: -> { object.active }

      def sections
        object.sections.published
      end
    end
  end
end
