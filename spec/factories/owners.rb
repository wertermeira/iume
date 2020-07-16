FactoryBot.define do
  factory :owner do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    provider { 'email' }
    password { Faker::Internet.password(min_length: 10, max_length: 20) }
    account_status { %w[pending blocked verified].sample }
  end
end
