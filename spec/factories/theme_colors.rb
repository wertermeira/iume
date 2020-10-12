FactoryBot.define do
  factory :theme_color do
    color { Faker::Color.hex_color }
  end
end
