FactoryBot.define do
  factory :product do
    section { nil }
    name { "MyString" }
    description { "MyText" }
    price { 1 }
    active { "" }
  end
end
