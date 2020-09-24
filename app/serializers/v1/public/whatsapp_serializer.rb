module V1
  module Public
    class WhatsappSerializer < ActiveModel::Serializer
      attributes :active
      has_one :phone, serializer: V1::PhoneSerializer
    end
  end
end
