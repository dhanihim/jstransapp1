class AddDocumentPathToAssignmentUpdate < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_updates, :document_path, :string
  end
end
