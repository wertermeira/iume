class CreateOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :owners do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.string :password_digest
      t.integer :account_status

      t.timestamps
    end
    add_index :owners, :email, unique: true
  end
end
