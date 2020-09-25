FactoryBot.define do
  factory :owner do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    provider { 'email' }
    password { Faker::Internet.password(min_length: 10, max_length: 20) }
    account_status { %w[pending blocked verified].sample }

    factory :owner_with_products do
      transient do
        products_count { 5 }
      end

      after(:create) do |owner, evaluator|
        restaurant = create(:restaurant, owner: owner)
        section = create(:section, restaurant: restaurant)
        create_list(:product, evaluator.products_count, section: section, image: nil)
        owner.reload
      end
    end
  end
end
