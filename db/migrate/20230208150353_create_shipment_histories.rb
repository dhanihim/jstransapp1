class CreateShipmentHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :shipment_histories do |t|
      t.integer :shipment_from_id
      t.integer :shipment_to_id
      t.string :description

      t.timestamps
    end
  end
end
