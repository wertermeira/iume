class Product < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  belongs_to :section

  validates :name, presence: true
  validates :name, length: { maximum: 200}, allow_blank: true
  validates :description, length: { minimum:20, maximum: 500 }, allow_blank: true

  has_one_base64_attached :image
  validates :image,
            content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'],
            size: { less_than: 2.megabytes }
end
