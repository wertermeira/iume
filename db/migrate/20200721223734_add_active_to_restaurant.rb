class AddActiveToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :active, :boolean, default: false
  end
end
