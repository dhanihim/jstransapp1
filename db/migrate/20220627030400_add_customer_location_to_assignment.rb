class AddCustomerLocationToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :pickup_location, :string
    add_column :assignments, :destination_location, :string
  end
end
