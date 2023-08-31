class AddStartedAttoCustomerLocationPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_location_pricelists, :started_at, :date
  end
end
