module V1
  class CitySerializer < ActiveModel::Serializer
    attributes :id, :name, :capital
    has_one :state, serializer: V1::StateSerializer
  end
end
