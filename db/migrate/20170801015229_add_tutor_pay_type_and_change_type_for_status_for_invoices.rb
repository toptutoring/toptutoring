class AddTutorPayTypeAndChangeTypeForStatusForInvoices < ActiveRecord::Migration[5.1]
  def up
    add_column :invoices, :tutor_pay_cents, :integer
    change_column :invoices, :status, :string
  end

  def down
    remove_column :invoices, :tutor_pay_cents
  end
end
