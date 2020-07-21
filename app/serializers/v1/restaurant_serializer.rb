module V1
  class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :slug, :active
  end
end
