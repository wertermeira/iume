class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.boolean :capital, default: false
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
