class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_details, dependent: :destroy

  validates :order_details, presence: true, on: :endpoint
  validates_associated :order_details
  before_validation :restaurant_ability

  accepts_nested_attributes_for :order_details, reject_if: :all_blank

  before_create :generate_uid

  private

  def generate_uid
    self.uid = loop do
      random_token = SecureRandom.alphanumeric(10)
      break random_token unless Order.exists?(uid: random_token)
    end
  end

  def restaurant_ability
    return if ToolWhatsapp.find_by(restaurant_id: restaurant_id)&.active

    errors.add(:restaurant, I18n.t('errors.messages.tools_whatsapp_required'))
  end
end
