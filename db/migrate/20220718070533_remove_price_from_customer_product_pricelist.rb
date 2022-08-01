class RemovePriceFromCustomerProductPricelist < ActiveRecord::Migration[6.1]
  def change
    remove_column :customer_product_pricelists, :per20ft, :string
    remove_column :customer_product_pricelists, :per40ft, :string
    remove_column :customer_product_pricelists, :per20od, :string
    remove_column :customer_product_pricelists, :per21ft, :string
    remove_column :customer_product_pricelists, :per20fr, :string
    remove_column :customer_product_pricelists, :per40fr, :string
  end
end
