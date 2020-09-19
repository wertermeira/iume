class CreatePhones < ActiveRecord::Migration[6.0]
  def change
    create_table :phones do |t|
      t.references :phoneable, polymorphic: true, null: false
      t.string :number

      t.timestamps
    end
  end
end
