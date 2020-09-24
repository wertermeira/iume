module V1
  module Tools
    class WhatsappSerializer < ActiveModel::Serializer
      attributes :active, :created_at, :updated_at
      has_one :phone, serializer: V1::PhoneSerializer
    end
  end
end
