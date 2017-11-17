class AddApproverToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :approver_id, :integer
  end
end
