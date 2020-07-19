module V1
  class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :slug
  end
end
