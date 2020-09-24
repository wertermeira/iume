FactoryBot.define do
  factory :tool_whatsapp do
    restaurant { create(:restaurant) }
    phone { nil }
    before :create do |whatsapp|
      whatsapp.phone = create(:phone, phoneable: whatsapp.restaurant) if whatsapp.phone.blank?
    end
  end
end
