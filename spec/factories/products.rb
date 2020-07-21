FactoryBot.define do
  factory :product do
    section { create(:section) }
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false) }
    price { Faker::Number.decimal(l_digits: 2) }
    active { true }
  end
end
