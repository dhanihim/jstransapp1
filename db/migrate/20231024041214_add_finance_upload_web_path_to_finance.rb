class AddFinanceUploadWebPathToFinance < ActiveRecord::Migration[6.1]
  def change
    add_column :finances, :upload_web_path, :string
  end
end
