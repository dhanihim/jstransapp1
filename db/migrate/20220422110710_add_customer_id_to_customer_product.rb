class AddCustomerIdToCustomerProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_products, :customer_id, :integer
    add_index :customer_products, :customer_id
  end
end
