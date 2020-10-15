class Restaurant < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :owner
  belongs_to :theme_color, optional: true

  attr_accessor :image_destroy

  has_many :sections
  has_many :unscope_sections, -> { unscope(where: :deleted) }, class_name: 'Section', inverse_of: :restaurant, dependent: :destroy
  has_many :products, through: :sections
  has_many :phones, as: :phoneable, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tool_whatsapp, dependent: :destroy

  accepts_nested_attributes_for :phones, allow_destroy: true, limit: 4, reject_if: :all_blank, update_only: true
  accepts_nested_attributes_for :address, allow_destroy: false, reject_if: :all_blank, update_only: true

  validates :name, presence: true
  validates :slug, presence: true, on: :update
  validates :slug, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validates :slug, slugger: true, on: :update, allow_blank: true
  validates :slug, length: { minimum: 3, maximum: 200 }, allow_blank: true, on: :update

  has_one_base64_attached :image
  validates :image,
            content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'],
            size: { less_than: 4.megabytes }

  after_create :notification_slack, :save_color_default
  before_update :purge_image, if: -> { image_destroy }
  before_create :generate_uid

  private

  def save_color_default
    self.theme_color = ThemeColor.first
  end

  def purge_image
    self.image = nil if image.attached?
  end

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

  def notification_slack
    message = "Olá! <#{ENV['FRONTEND_URL']}/qr/#{uid}|#{name}> acabou de ser registrado :smile:"
    SlackNotifyJob.perform_later(message: message, channel: ENV.fetch('SLACK_NOTIFY_CHANNEL', '#iume-notifications'))
  end
end
