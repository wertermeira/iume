class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sort_by_position, -> { order(position: :asc) }


  def for_trash
    update(deleted: true)
  end
end
