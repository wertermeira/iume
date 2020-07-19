FactoryBot.define do
  factory :section do
    name { "MyString" }
    restaurant { nil }
    position { 1 }
    active { false }
  end
end
