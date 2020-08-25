module V1
  class OwnerSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :login_count, :created_at, :updated_at
  end
end
