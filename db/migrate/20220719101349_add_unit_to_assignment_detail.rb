class AddUnitToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :unit, :string
  end
end
