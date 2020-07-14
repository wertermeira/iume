class AuthenticateToken < ApplicationRecord
  belongs_to :authenticateable, polymorphic: true
  before_create :generate_token, :time_expires_in

  attr_accessor :authenticator

  def update_token
    update(body: generate_token, expires_in: time_expires_in)
  end

  def authenticated
    authenticateable_type.safe_constantize.find(authenticateable_id)
  end

  private

  def time_expires_in
    self.expires_in = (Time.now.utc + 30.days).to_i
  end

  def generate_token
    self.body = loop do
      random_token = SecureRandom.alphanumeric(100)
      break random_token unless AuthenticateToken.exists?(body: random_token)
    end
  end
end
