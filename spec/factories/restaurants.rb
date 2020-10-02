FactoryBot.define do
  factory :restaurant do
    owner { create(:owner) }
    name { Faker::Company.name }
    active { true }

    factory :restaurant_with_tool_whatsapp do
      transient do
        active { true }
      end

      after :create do |restaurant, evaluator|
        create(:address, addressable: restaurant)
        create(:tool_whatsapp, restaurant: restaurant, active: evaluator.active)
      end
    end
  end
end
