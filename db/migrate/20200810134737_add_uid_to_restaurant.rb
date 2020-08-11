class AddUidToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :uid, :string
    add_index :restaurants, :uid, unique: true
  end
end
