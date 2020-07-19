class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.references :owner, null: false, foreign_key: true
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :restaurants, :slug, unique: true
  end
end
