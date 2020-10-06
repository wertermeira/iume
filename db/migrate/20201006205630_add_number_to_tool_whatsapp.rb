class AddNumberToToolWhatsapp < ActiveRecord::Migration[6.0]
  def change
    remove_column :tool_whatsapps, :phone_id
  end
end
