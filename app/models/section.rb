class Section < ApplicationRecord
  belongs_to :restaurant, touch: true

  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validate :max_sections_restaurant, on: :create

  scope :published, -> { joins(:restaurant).where(active: true, restaurants: { active: true }) }

  before_create do
    self.position = restaurant.sections.count if position.blank?
  end

  private

  def max_sections_restaurant
    max_sections = ENV.fetch('MAX_SECTION_RESTAURANT', 10)
    return if restaurant.sections.count < max_sections.to_i

    errors.add(:max_sections, I18n.t('errors.messages.limit_max_items', max: max_sections, item: 'seções'))
  end
end
