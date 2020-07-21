class Section < ApplicationRecord
  belongs_to :restaurant

  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
end
