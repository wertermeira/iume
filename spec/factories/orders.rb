FactoryBot.define do
  factory :order do
    restaurant { create(:restaurant) }
    before :create do |order|
      create(:address, addressable: order.restaurant)
      create(:tool_whatsapp, restaurant: order.restaurant, active: true)
    end
  end
end
