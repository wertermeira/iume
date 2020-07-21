class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sort_by_position, -> { order(position: :asc) }
end
