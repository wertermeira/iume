module V1
  class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created_at, :updated_at
  end
end
