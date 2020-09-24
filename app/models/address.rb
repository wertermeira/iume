class Address < ApplicationRecord
  belongs_to :city, optional: true
  belongs_to :addressable, polymorphic: true

  validates :street, :cep, :neighborhood, presence: true
  validates :street, :neighborhood, length: { maximum: 200 }
  validates :cep, cep: true, if: -> { cep.present? }

  after_validation :save_location, if: -> { errors.blank? }

  private

  def save_location
    data = Correios::CEP::AddressFinder.get(cep)

    return if data.blank?

    self.city = State.find_by(acronym: data.dig(:state)).cities.find_by(name: data.dig(:city))
    errors.add(:cep, 'Error tente novamente') if city.blank?
  end
end
