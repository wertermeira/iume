module V1
  class ProductSerializer < V1::BaseSerializer
    attributes :id, :name, :description, :price, :active, :position,
               :image, :created_at, :updated_at
  end
end
