class CreateCustomerProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_products do |t|
      t.string :name
      t.string :uom
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
