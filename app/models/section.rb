class Section < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true

  scope :sort_by_position, -> { order(position: :asc) }
end
