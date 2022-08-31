class AddDescriptionToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :description, :string
  end
end
