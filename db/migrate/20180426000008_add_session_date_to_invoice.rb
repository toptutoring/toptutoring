class AddSessionDateToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :session_date, :date
  end
end
