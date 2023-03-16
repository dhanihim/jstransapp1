class AddToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :code, :string
    add_column :assignments, :subcode, :integer
  end
end
