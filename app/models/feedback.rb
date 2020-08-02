class Feedback < ApplicationRecord
  belongs_to :owner

  validates :screen, length: { maximum: 200 }
  validates :body, length: { minimum: 10, maximum: 1000 }, allow_blank: true
  validates :body, presence: true
end
