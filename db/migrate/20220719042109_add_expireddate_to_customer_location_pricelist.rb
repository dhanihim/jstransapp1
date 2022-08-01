class AddExpireddateToCustomerLocationPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_location_pricelists, :expireddate, :date
  end
end
