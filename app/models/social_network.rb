class SocialNetwork < ApplicationRecord
  belongs_to :restaurant

  enum provider: { facebook: 0, instagram: 1 }

  validates :restaurant_id, uniqueness: { scope: :provider }
  validates :username, :provider, presence: true
  validates :username, length: { maximum: 200 }, allow_blank: true
end
