class CreateAgents < ActiveRecord::Migration[6.1]
  def change
    create_table :agents do |t|
      t.string :name
      t.string :address
      t.string :contact
      t.integer :type
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
