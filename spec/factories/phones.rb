FactoryBot.define do
  factory :phone do
    number { "11-#{rand(9999..99_999)}-#{rand(1000..9999)}" }
    phoneable { nil }
  end
end
