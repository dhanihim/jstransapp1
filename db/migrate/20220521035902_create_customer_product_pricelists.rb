class CreateCustomerProductPricelists < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_product_pricelists do |t|
      t.integer :per20ft
      t.integer :per40ft
      t.integer :per20od
      t.integer :per21ft
      t.integer :per20fr
      t.integer :per40fr
      t.integer :ppncategory
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
