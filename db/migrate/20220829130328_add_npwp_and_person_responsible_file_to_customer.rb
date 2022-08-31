class AddNpwpAndPersonResponsibleFileToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :npwp_file, :string
    add_column :customers, :person_responsible_file, :string
  end
end
