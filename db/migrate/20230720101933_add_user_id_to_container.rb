class AddUserIdToContainer < ActiveRecord::Migration[6.1]
  def change
    add_column :containers, :user_id, :integer
  end
end
