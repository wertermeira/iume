class ThemeColor < ApplicationRecord
  has_many :restaurants, dependent: :nullify
  validates :color, presence: true
end
