class AddUserIdToFinance < ActiveRecord::Migration[6.1]
  def change
    add_column :finances, :user_id, :integer
  end
end
