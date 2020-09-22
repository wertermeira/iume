class AddDescriptionToSection < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :description, :text
  end
end
