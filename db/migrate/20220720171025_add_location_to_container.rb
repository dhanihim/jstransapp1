class AddLocationToContainer < ActiveRecord::Migration[6.1]
  def change
    add_column :containers, :pol, :integer
    add_column :containers, :pod, :integer
  end
end
