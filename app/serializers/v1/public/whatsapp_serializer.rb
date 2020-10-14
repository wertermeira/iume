module V1
  module Public
    class WhatsappSerializer < V1::BaseSerializer
      attributes :active
      has_one :phone, serializer: V1::PhoneSerializer
    end
  end
end
