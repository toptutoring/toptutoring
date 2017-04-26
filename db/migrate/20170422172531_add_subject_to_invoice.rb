class AddSubjectToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :subject, :string
  end
end
