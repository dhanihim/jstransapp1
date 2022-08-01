class RemovePortFromShipment < ActiveRecord::Migration[6.1]
  def change
    remove_column :shipments, :pol, :string
    remove_column :shipments, :pod, :string
  end
end
