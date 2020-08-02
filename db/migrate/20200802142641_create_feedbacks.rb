class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.references :owner, null: false, foreign_key: true
      t.string :screen
      t.text :body

      t.timestamps
    end
  end
end
