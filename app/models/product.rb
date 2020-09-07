class Product < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  belongs_to :section, touch: true

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
    max_products = ENV.fetch('MAX_PRODUCT_SECTION', 50)
    return if section.products.count < max_products.to_i

    errors.add(:section_id, I18n.t('less_than_or_equal_to', count: max_products))
  end
end
