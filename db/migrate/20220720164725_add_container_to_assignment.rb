class AddContainerToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :container_id, :integer
  end
end
