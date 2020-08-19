FactoryBot.define do
  factory :section do
    name { Faker::Company.name }
    restaurant { create(:restaurant) }
    position { 0 }
    active { true }
  end
end
