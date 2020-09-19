module V1
  class PhoneSerializer < ActiveModel::Serializer
    attributes :id, :number, :created_at, :updated_at
  end
end
