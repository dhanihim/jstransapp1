class AddDatetimeToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :edited_at, :datetime
    add_column :customers, :sync_at, :datetime
  end
end
