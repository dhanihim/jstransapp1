class ChangeDocumentStatusInAssignment < ActiveRecord::Migration[6.1]
  def change
    change_column(:assignments, :document_status, :string)
  end
end
