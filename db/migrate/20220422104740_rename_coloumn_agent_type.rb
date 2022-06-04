class RenameColoumnAgentType < ActiveRecord::Migration[6.1]
  def change
    rename_column :agents, :type, :pickupordooring
  end
end
