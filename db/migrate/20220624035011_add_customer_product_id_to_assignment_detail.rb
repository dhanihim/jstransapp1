class AddCustomerProductIdToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :customer_product_id, :integer
    add_index :assignment_details, :customer_product_id
  end
end
