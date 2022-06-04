class AddLocationIdToCustomerProductPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_product_pricelists, :location_id, :integer
    add_index :customer_product_pricelists, :location_id
  end
end
