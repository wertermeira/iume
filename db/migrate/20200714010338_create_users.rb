class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.string :password_digest
      t.integer :account_status

      t.timestamps
    end
    add_index :users, %i[email provider], unique: true
  end
end
