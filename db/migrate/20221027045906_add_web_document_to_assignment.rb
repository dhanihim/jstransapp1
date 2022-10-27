class AddWebDocumentToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :document_web_path, :string
    add_column :assignments, :dooring_web_path, :string
    add_column :assignments, :payment_web_path, :string
  end
end
