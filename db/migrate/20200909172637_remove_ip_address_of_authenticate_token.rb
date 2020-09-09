class RemoveIpAddressOfAuthenticateToken < ActiveRecord::Migration[6.0]
  def change
    remove_column :authenticate_tokens, :ip_address
  end
end
