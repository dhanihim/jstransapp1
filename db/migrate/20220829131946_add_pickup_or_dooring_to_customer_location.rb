class AddPickupOrDooringToCustomerLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_locations, :pickup_or_dooring, :string
  end
end
