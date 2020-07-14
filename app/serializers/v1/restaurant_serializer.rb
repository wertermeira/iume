module V1
  class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created, :updated
  end
end
