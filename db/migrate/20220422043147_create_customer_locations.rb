class CreateCustomerLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_locations do |t|
      t.string :address
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
