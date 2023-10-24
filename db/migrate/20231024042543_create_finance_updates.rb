class CreateFinanceUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_updates do |t|
      t.string :uid
      t.string :document_path
      t.string :description

      t.timestamps
    end
  end
end
