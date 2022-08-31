class AddPpnAndGrandTotalToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :ppn, :integer
    add_column :assignment_details, :grand_total, :integer
  end
end
