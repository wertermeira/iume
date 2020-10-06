FactoryBot.define do
  factory :tool_whatsapp do
    restaurant { create(:restaurant) }
    association(:phone)
    active { false }
  end
end
