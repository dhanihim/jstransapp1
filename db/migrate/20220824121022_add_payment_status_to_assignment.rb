class AddPaymentStatusToAssignment < ActiveRecord::Migration[6.1]
  def change
    add_column :assignments, :payment_status, :string
  end
end
