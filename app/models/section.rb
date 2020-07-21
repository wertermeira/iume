class Section < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true
  validates :name, length: { minimum: 3, maximum: 200 }, allow_blank: true

  scope :sort_by_position, -> { order(position: :asc) }

  def self.update_sort(ids)
    ids.each_with_index do |id, index|
      section = Section.find_by(id: id)
      next if section.blank?

      section.position = index
      section.save(validate: false)
    end
  end
end
