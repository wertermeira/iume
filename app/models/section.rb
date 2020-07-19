class Section < ApplicationRecord
  belongs_to :restaurant

  validates :position, uniqueness: { scope: :restaurant_id }

  before_create :set_position, if: -> { position.blank? }

  private

  def set_position
    section_position = restaurant.sections.order(position: :desc).first
    self.position = section_position.position + 1 if section_position.present?
  end
end
