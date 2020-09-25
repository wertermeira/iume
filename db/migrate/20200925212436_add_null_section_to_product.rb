class AddNullSectionToProduct < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :section_id, :integer, null: true
  end
end
