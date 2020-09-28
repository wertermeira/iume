class Phone < ApplicationRecord
  belongs_to :phoneable, polymorphic: true

  has_one :tool_whatsapp, dependent: :destroy

  validates :number, phone: true, allow_blank: true
  validates :number, presence: true
  validates :number, uniqueness: { scope: %i[phoneable_type phoneable_id] }
end
