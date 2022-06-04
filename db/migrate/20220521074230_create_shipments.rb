class CreateShipments < ActiveRecord::Migration[6.1]
  def change
    create_table :shipments do |t|
      t.string :uid
      t.string :shipname
      t.string :voyage
      t.date :estimateddeparture
      t.date :estimatedarrival
      t.date :actualdeparture
      t.date :actualarrival
      t.integer :active
      t.string :description

      t.timestamps
    end
  end
end
