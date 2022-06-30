class AddAgentToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :agent_id, :string
    add_index :assignments, :agent_id
  end
end
