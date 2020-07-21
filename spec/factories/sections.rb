FactoryBot.define do
  factory :section do
    name { Faker::Company.name }
    restaurant { create(:restaurant) }
    position { '' }
    active { true }
  end
end
