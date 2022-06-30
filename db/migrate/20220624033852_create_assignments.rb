class CreateAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :assignments do |t|
      t.string :uid
      t.datetime :pickuptime
      t.integer :document_status
      t.integer :active

      t.timestamps
    end
  end
end
