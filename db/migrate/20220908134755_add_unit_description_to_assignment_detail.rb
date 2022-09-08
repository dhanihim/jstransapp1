class AddUnitDescriptionToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :unit_description, :string
  end
end
