class AddCustomerToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :customer_id, :string
    add_index :assignments, :customer_id
  end
end
