class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :contact
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
