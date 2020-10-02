class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true }, allow_blank: true
  after_validation :validate_order_restaurant, if: -> { errors.blank? }

  before_create do
    self.unit_price = product.price
  end

  private

  def validate_order_restaurant
    return if order.restaurant.products.find_by(id: product_id) && product.active

    errors.add(:product_id, I18n.t('errors.messages.invalid'))
  end
end
