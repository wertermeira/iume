class User < ApplicationRecord
  has_secure_password

  enum account_status: { pending: 0, verified: 1, blocked: 2 }, _prefix: :account

  before_create do
    self.provider = 'email'
  end

  validates :name, :email, presence: true
  validates :password, presence: true, on: :create
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validates :password, length: { minimum: 8, maximum: 20 }, allow_blank: true
  validates :password, confirmation: true
  validates :email, email: true, allow_blank: true
  validates :email, uniqueness: { scope: :provider }
end
