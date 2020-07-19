class Restaurant < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :owner

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
end
