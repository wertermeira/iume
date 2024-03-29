class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.references :restaurant, null: false, foreign_key: true
      t.integer :position
      t.boolean :active, default: false

      t.timestamps
    end
    add_index :sections, :position
  end
end
