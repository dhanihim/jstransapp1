class AddDooringAgentIdToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :dooring_agent_id, :integer
  end
end
