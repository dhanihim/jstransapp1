class AddStatusToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :status, :integer
  end
end
