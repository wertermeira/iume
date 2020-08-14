class AvailabilitySlugValidation
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :slug

  validates :slug, presence: true
  validates :slug, slugger: true, allow_blank: true
  validates :slug, length: { minimum: 3, maximum: 200 }, allow_blank: true
  validate :availability_restaurant

  private

  def availability_restaurant
    errors.add(:slug, I18n.t('errors.messages.taken')) if Restaurant.find_by(slug: slug)
  end
end
