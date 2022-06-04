class AddCustomerIdToCustomerLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_locations, :customer_id, :integer
    add_index :customer_locations, :customer_id
  end
end
