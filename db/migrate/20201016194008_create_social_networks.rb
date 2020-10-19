class CreateSocialNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :social_networks do |t|
      t.integer :provider, null: false
      t.references :restaurant, null: false, foreign_key: true
      t.string :username

      t.timestamps
    end
    add_index :social_networks, %i[restaurant_id provider], unique: true, name: 'index_restaurant_id_provider'
  end
end
