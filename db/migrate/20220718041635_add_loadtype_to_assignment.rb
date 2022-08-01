class AddLoadtypeToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :loadtype, :string
  end
end
