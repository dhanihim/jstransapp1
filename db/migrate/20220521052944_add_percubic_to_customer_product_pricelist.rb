class AddPercubicToCustomerProductPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_product_pricelists, :percubic, :integer
  end
end
