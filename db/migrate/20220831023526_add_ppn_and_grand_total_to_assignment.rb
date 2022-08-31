class AddPpnAndGrandTotalToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :ppn, :integer
    add_column :assignments, :grand_total, :integer
  end
end
