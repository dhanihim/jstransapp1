class AddFinanceReferenceToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :finance_reference, :integer
  end
end
