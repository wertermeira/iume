FactoryBot.define do
  image = Base64.encode64(File.open(File.join(Rails.root, './spec/support/fixtures/image.jpg'), &:read))
  factory :product do
    section { create(:section) }
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false) }
    price { Faker::Number.decimal(l_digits: 2) }
    active { true }
    image { { data: "data:image/jpeg;base64,#{image}" } }
  end
end
