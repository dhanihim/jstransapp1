class AddLogToCustomerLocationPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_location_pricelists, :log, :string
  end
end
