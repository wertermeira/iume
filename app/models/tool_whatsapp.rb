class ToolWhatsapp < ApplicationRecord
  belongs_to :restaurant

  has_one :phone, as: :phoneable, dependent: :destroy

  accepts_nested_attributes_for :phone, allow_destroy: true, reject_if: :all_blank, update_only: true

  validate :validate_restaurant_address, if: -> { active }
  validates :phone, presence: true, on: :create

  private

  def validate_restaurant_address
    return if restaurant.address.present?

    errors.add(:active, I18n.t('errors.messages.tools_address_required'))
  end
end
