class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.references :restaurant, null: false, foreign_key: true
      t.integer :position
      t.boolean :active

      t.timestamps
    end
    add_index :sections, %i[restaurant_id position], unique: true
  end
end
