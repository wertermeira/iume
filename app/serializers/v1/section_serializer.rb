module V1
  class SectionSerializer < ActiveModel::Serializer
    attributes :id, :name, :position, :active, :created_at, :updated_at
  end
end