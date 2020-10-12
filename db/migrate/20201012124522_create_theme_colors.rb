class CreateThemeColors < ActiveRecord::Migration[6.0]
  def change
    create_table :theme_colors do |t|
      t.string :color

      t.timestamps
    end
  end
end
