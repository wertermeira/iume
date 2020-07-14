class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.string :password_digest
      t.integer :account_status

      t.timestamps
    end
    add_index :restaurants, :email, unique: true
  end
end
