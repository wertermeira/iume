class V1::SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :created_at, :updated_at
end
