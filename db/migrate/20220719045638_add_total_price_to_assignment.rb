class AddTotalPriceToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :total_price, :integer
  end
end
