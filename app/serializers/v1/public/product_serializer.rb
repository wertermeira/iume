module V1
  module Public
    class ProductSerializer < V1::BaseSerializer
      attributes :id, :name, :description, :price, :position,
                 :image, :created_at, :updated_at
    end
  end
end
