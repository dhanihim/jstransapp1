class CreateContainers < ActiveRecord::Migration[6.1]
  def change
    create_table :containers do |t|
      t.string :number
      t.string :sealnumber
      t.string :type
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
