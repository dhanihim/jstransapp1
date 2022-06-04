class AddPolToShipment < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :pol, :string
  end
end
