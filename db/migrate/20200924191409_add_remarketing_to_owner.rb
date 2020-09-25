class AddRemarketingToOwner < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :remarketing, :integer, default: 0
  end
end
