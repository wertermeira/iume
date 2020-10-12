module V1
  class PhoneSerializer < V1::BaseSerializer
    attributes :id, :number, :created_at, :updated_at
  end
end
