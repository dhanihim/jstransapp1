class AddContainerToAssignmentUpdate < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_updates, :container, :string
  end
end
