class Region < ApplicationRecord
  has_many :states, dependent: :destroy
  has_many :cities, through: :states
end
