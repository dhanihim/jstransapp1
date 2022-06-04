class RenameTypeFromContainer < ActiveRecord::Migration[6.1]
  def change
    rename_column :containers, :type, :size
  end
end
