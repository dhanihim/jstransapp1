class AddPodToShipment < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :pod, :string
  end
end
