class Phone < ApplicationRecord
  belongs_to :phoneable, polymorphic: true

  validates :number, phone: true, allow_blank: true
  validates :number, uniqueness: { scope: %i[phoneable_type phoneable_id] }
end
