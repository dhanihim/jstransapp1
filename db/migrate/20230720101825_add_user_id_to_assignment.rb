class AddUserIdToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :user_id, :integer
  end
end
