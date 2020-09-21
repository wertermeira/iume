FactoryBot.define do
  factory :region do
    name { Faker::Address.community }
  end
end
