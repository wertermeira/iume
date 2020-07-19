class Owner < ApplicationRecord
  has_secure_password

  has_many :authenticate_tokens, as: :authenticateable, dependent: :destroy
  has_many :restaurants, dependent: :destroy

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
end
