class AddNotesToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :note, :string
  end
end
