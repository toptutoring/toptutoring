class AddTypetoInvoice < ActiveRecord::Migration[5.1]
  def change
    rename_column :invoices, :tutor_id, :submitter_id
    rename_column :invoices, :tutor_pay_cents, :submitter_pay_cents
    add_column :invoices, :submitter_type, :integer, default: 0
  end
end
