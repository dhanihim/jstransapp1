class AddLocationIdToCustomerLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :customer_locations, :location_id, :integer
    add_index :customer_locations, :location_id
  end
end
