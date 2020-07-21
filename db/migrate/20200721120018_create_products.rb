class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.references :section, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.integer :position
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
