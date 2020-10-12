module V1
  class SectionSerializer < V1::BaseSerializer
    attributes :id, :name, :description, :position, :active, :created_at, :updated_at
  end
end
