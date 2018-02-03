class AddSessionTypeToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :online, :boolean, default: true
  end
end
