module V1
  module Public
    class SectionSerializer < ActiveModel::Serializer
      attributes :id, :name, :position
    end
  end
end
