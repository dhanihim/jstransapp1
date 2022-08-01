class AddPortToShipment < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :pol, :integer
    add_column :shipments, :pod, :integer
  end
end
