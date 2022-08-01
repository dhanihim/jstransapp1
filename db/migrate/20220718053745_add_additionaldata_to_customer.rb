class AddAdditionaldataToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :npwp, :string
    add_column :customers, :person_responsible, :string
    add_column :customers, :person_responsible_uid, :string
  end
end
