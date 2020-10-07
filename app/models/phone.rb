class Phone < ApplicationRecord
  belongs_to :phoneable, polymorphic: true

  validates :number, phone: true, allow_blank: true
  validates :number, presence: true
  validates :number, uniqueness: { scope: %i[phoneable_type phoneable_id] }

  after_destroy :disable_whatsapp, if: -> { phoneable.class.name == 'ToolWhatsapp' }

  private

  def disable_whatsapp
    phoneable.update(active: false)
  end
end
