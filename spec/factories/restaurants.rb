FactoryBot.define do
  factory :restaurant do
    owner { create(:owner) }
    name { Faker::Company.name }
    active { true }
  end
end
