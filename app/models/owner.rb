class Owner < ApplicationRecord
  has_secure_password

  has_many :authenticate_tokens, as: :authenticateable, dependent: :destroy
  has_many :restaurants, dependent: :destroy
  has_many :sections, through: :restaurants
  has_many :products, through: :sections
  has_many :feedbacks, dependent: :destroy

  enum account_status: { pending: 0, verified: 1, blocked: 2 }, _prefix: :account

  before_create do
    self.provider = 'email'
    self.email = email&.downcase
  end

  validates :email, presence: true
  validates :password, presence: true, on: %i[create update_password]
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validates :password, length: { minimum: 8, maximum: 20 }, allow_blank: true
  validates :password, confirmation: true
  validates :email, email: true, allow_blank: true
  validates :email, uniqueness: true

  def self.remarketings
    or_owner = Owner.left_joins(:products)
                    .where('remarketing = 1 AND products.id IS NULL AND owners.created_at < :tree_days', tree_days: Time.now.utc - 3.days)
    Owner.left_joins(:products)
         .where('remarketing = 0 AND products.id IS NULL AND owners.created_at < :tree_days', tree_days: Time.now.utc - 1.day)
         .or(or_owner)
  end
end
