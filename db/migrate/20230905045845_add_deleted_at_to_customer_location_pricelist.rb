class AddDeletedAtToCustomerLocationPricelist < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_location_pricelists, :deleted_at, :date
    add_column :customer_location_pricelists, :deleted_by, :integer
  end
end
