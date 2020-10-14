module V1
  module Tools
    class WhatsappSerializer < V1::BaseSerializer
      attributes :active, :created_at, :updated_at
      has_one :phone, serializer: V1::PhoneSerializer
    end
  end
end
