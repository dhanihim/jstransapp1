class ChangeAgentDatatype < ActiveRecord::Migration[6.1]
  def change
    change_column(:agents, :type, :string)
  end
end
