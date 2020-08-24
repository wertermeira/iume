module V1
  module Public
    class RestaurantSerializer < ActiveModel::Serializer
      attributes :id, :name, :slug, :active
      has_many :sections, serializer: V1::Public::SectionSerializer

      def sections
        if scope[:current_user].present? && scope[:current_user].restaurants.find_by(id: object.id)
          object.sections.where(active: true)
        elsif object.active
          object.sections.published
        end
      end

      def id
        object.uid
      end
    end
  end
end
