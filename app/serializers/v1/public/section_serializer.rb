module V1
  module Public
    class SectionSerializer < V1::BaseSerializer
      attributes :id, :name, :description, :position
    end
  end
end
