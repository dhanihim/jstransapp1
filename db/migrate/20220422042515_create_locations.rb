class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
