class RemoveCustomerLocationFromCustomerLocationPricelist < ActiveRecord::Migration[6.1]
  def change
    remove_column :customer_location_pricelists, :customer_location_from, :integer
    remove_column :customer_location_pricelists, :customer_location_to, :integer
  end
end
