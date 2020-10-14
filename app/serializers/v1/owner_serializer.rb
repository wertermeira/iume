module V1
  class OwnerSerializer < V1::BaseSerializer
    attributes :id, :name, :email, :login_count, :created_at, :updated_at
  end
end
