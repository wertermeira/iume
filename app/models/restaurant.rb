class Restaurant < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :owner

  has_many :sections, dependent: :destroy
  has_many :products, through: :sections
  has_many :phones, as: :phoneable, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :phones, allow_destroy: true, limit: 4, reject_if: :all_blank, update_only: true
  accepts_nested_attributes_for :address, allow_destroy: false, reject_if: :all_blank, update_only: true

  validates :name, presence: true
  validates :slug, presence: true, on: :update
  validates :slug, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validates :slug, slugger: true, on: :update, allow_blank: true
  validates :slug, length: { minimum: 3, maximum: 200 }, allow_blank: true, on: :update

  before_create :generate_uid

  private

  def slug_candidates
    [
      :name,
      [:name, owner.id]
    ]
  end

  def generate_uid
    self.uid = loop do
      random_token = SecureRandom.alphanumeric(10)
      break random_token unless Restaurant.exists?(uid: random_token)
    end
  end
end
