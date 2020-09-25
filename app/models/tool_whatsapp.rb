class ToolWhatsapp < ApplicationRecord
  belongs_to :restaurant
  belongs_to :phone

  after_validation :validate_phone, if: -> { errors.blank? }
  validate :validate_restaurant_address, if: -> { active }

  private

  def validate_restaurant_address
    return if restaurant.address.present?

    errors.add(:active, I18n.t('errors.messages.tools_address_required'))
  end

  def validate_phone
    return if restaurant.phones.find_by(id: phone_id)

    errors.add(:phone_id, I18n.t('errors.messages.invalid'))
  end
end
