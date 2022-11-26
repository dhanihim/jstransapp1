class AddPriceAdjustmentToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :price_adjustment, :integer, default: 0
  end
end
