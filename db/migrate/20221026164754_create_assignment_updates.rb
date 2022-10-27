class CreateAssignmentUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :assignment_updates do |t|
      t.string :uid

      t.timestamps
    end
  end
end
