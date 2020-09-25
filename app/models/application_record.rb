class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sort_by_position, -> { order(position: :asc) }
  scope :in_the_trash, -> { unscope(where: :deleted).where(deleted: true) }
  scope :unscope_model, -> { unscope(where: :deleted) }

  def for_trash
    update(deleted: true)
  end
end
