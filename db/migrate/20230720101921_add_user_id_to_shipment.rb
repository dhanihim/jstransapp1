class AddUserIdToShipment < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :user_id, :integer
  end
end
