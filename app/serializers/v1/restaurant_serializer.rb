module V1
  class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :slug, :active

    def id
      object.uid
    end
  end
end
