module V1
  class StateSerializer < ActiveModel::Serializer
    attributes :id, :name, :acronym
  end
end
