class AddPriceToAssignmentDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_details, :price, :integer
  end
end
