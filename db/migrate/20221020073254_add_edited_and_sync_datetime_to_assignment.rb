class AddEditedAndSyncDatetimeToAssignment< ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :edited_at, :datetime
    add_column :assignments, :sync_at, :datetime
  end
end
