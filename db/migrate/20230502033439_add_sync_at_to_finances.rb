class AddSyncAtToFinances < ActiveRecord::Migration[6.1]
  def change
    add_column :finances, :sync_at, :datetime
    add_column :finances, :edited_at, :datetime
  end
end
