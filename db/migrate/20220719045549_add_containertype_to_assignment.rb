class AddContainertypeToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :containertype, :string
  end
end
