FactoryBot.define do
  image = Base64.encode64(File.open(File.join(Rails.root, './spec/support/fixtures/image.jpg'), &:read))
  factory :restaurant do
    owner { create(:owner) }
    name { Faker::Company.name }
    image { { data: "data:image/jpeg;base64,#{image}" } }
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
