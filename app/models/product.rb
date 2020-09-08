class Product < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  belongs_to :section, touch: true
  has_one :restaurant, through: :section
  has_one :owner, through: :restaurant

  MAX_PRODUCTS = ENV.fetch('MAX_PRODUCTS', 15).to_i

  attr_accessor :image_destroy

  validates :name, :price, presence: true
  validates :name, length: { maximum: 200 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :price, numericality: true, allow_blank: true
  validate :max_product_section, on: :create, if: -> { section.present? }

  has_one_base64_attached :image
  validates :image,
            content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'],
            size: { less_than: 4.megabytes }
  scope :published, -> { where(active: true) }

  before_update :purge_image, if: -> { image_destroy }
  before_create do
    self.position = section.products.count if position.blank?
  end

  private

  def purge_image
    self.image = nil if image.attached?
  end

  def max_product_section
    return if restaurant.products.count < MAX_PRODUCTS

    errors.add(:max_products, I18n.t('errors.messages.limit_max_items', max: MAX_PRODUCTS, item: 'produtos'))
  end
end
