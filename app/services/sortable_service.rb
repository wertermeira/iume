class SortableService
  def initialize(model: nil)
    @model = model
  end

  def update_sort(ids:)
    ids.each_with_index do |id, index|
      section = @model.safe_constantize.find_by(id: id)
      next if section.blank?

      section.position = index
      section.save(validate: false)
    end
  end
end
