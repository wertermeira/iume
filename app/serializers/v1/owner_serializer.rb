module V1
  class OwnerSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created_at, :updated_at
  end
end
