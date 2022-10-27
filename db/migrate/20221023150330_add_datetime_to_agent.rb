class AddDatetimeToAgent < ActiveRecord::Migration[6.1]
  def change
    add_column :agents, :edited_at, :datetime
    add_column :agents, :sync_at, :datetime
  end
end
