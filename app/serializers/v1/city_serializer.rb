module V1
  class CitySerializer < V1::BaseSerializer
    attributes :id, :name, :capital
    has_one :state, serializer: V1::StateSerializer
  end
end
