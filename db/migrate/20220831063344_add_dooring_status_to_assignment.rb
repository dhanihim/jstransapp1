class AddDooringStatusToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :dooring_status, :string
  end
end
