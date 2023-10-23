class AddUploadWebPathToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :upload_web_path, :string
  end
end
