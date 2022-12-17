class CreateFinances < ActiveRecord::Migration[6.1]
  def change
    create_table :finances do |t|
      t.string :uid
      t.string :total_billing
      t.date :payment_date
      t.string :payment_document
      t.string :description
      t.integer :active

      t.timestamps
    end
  end
end
