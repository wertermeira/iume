class AddDeletedToSectionAndProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :deleted, :boolean, default: false
    add_column :products, :deleted, :boolean, default: false
  end
end
