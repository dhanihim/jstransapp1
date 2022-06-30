class CreateAssignmentDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :assignment_details do |t|
      t.integer :quantity
      t.integer :total

      t.timestamps
    end
  end
end
