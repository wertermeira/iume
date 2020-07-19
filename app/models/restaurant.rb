class Restaurant < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :owner

  validates :name, presence: true
  validates :slug, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validates :slug, slugger: true, on: :update, allow_blank: true
  validates :slug, presence: true, on: :update
end
