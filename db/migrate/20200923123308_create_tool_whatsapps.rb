class CreateToolWhatsapps < ActiveRecord::Migration[6.0]
  def change
    create_table :tool_whatsapps do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.boolean :active, default: false
      t.references :phone, null: false, foreign_key: true

      t.timestamps
    end
  end
end
