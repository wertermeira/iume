class AddThemeColorToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_reference :restaurants, :theme_color, null: true, foreign_key: true, default: 1
  end
end
