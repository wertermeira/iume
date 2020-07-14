class CreateAuthenticateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :authenticate_tokens do |t|
      t.string :body
      t.datetime :last_used_at
      t.integer :expires_in
      t.string :ip_address
      t.string :user_agent
      t.references :authenticateable, polymorphic: true, null: false, index: { name: :authenticateable_type_and_authenticateable_id }

      t.timestamps
    end
    add_index :authenticate_tokens, :body, unique: true
  end
end
