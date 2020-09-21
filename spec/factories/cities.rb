FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    capital { false }
    state { State.last || create(:state) }
  end
end
