class AddDeletedByToFinance < ActiveRecord::Migration[6.1]
  def change
    add_column :finances, :deleted_by, :integer
  end
end
