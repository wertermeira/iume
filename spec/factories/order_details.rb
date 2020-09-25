FactoryBot.define do
  factory :order_detail do
    order { create(:order) }
    before :create do |order_detail|
      section = create(:section, restaurant: order_detail.order.restaurant)
      order_detail.product = create(:product, section: section)
    end
    quantity { 1 }
  end
end
