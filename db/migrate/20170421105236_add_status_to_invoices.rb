class AddStatusToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :status, :integer
  end
end
