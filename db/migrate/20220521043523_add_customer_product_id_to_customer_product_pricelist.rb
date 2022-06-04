class AddCustomerProductIdToCustomerProductPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_product_pricelists, :customer_product_id, :integer
    add_index :customer_product_pricelists, :customer_product_id
  end
end
