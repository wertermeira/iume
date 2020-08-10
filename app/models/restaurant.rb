class Restaurant < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :owner

  has_many :sections, dependent: :destroy
  has_many :products, through: :sections

  validates :name, presence: true
  validates :slug, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validates :slug, slugger: true, on: :update, allow_blank: true
  validates :slug, presence: true, on: :update

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
