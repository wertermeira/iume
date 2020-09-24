FactoryBot.define do
  factory :section do
    name { Faker::Company.name }
    description { 'txt here' }
    restaurant { create(:restaurant) }
    position { 0 }
    active { true }
    deleted { false }
  end
end
