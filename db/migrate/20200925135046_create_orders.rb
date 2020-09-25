class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :uid, null: false

      t.timestamps
    end
    add_index :orders, :uid, unique: true
  end
end
