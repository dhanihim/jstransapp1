class AddDocumentTypeToAssignmentUpdate < ActiveRecord::Migration[6.1]
  def change
    add_column :assignment_updates, :document_type, :integer
  end
end
