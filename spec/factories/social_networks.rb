FactoryBot.define do
  factory :social_network do
    provider { %w[facebook instagram].sample }
    restaurant { create(:restaurant) }
    username { 'username' }
  end
end
