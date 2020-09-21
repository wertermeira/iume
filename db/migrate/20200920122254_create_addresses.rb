class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :neighborhood
      t.references :city, null: true, foreign_key: true
      t.string :complement
      t.string :number
      t.string :reference
      t.string :cep
      t.references :addressable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
