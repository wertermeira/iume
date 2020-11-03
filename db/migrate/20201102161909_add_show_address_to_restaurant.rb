class AddShowAddressToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :show_address, :boolean, default: true
  end
end
