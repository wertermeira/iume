class AddLockVersionAndLoginCountToOwner < ActiveRecord::Migration[6.0]
  def change
    add_column :owners, :login_count, :integer, default: 0
    add_column :owners, :lock_version, :integer, default: 0
  end
end
