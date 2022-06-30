class AddAssignmentIdToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :assignment_id, :integer
    add_index :assignment_details, :assignment_id
  end
end
