FactoryBot.define do
  factory :state do
    name { Faker::Address.state }
    acronym { Faker::Address.state_abbr }
    region { Region.last || create(:region) }
  end
end
