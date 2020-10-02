class CreateOrderDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :unit_price, precision: 8, scale: 2
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
