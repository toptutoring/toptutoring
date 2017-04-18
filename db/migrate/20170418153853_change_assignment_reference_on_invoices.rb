class ChangeAssignmentReferenceOnInvoices < ActiveRecord::Migration[5.0]
  def change
    remove_index :invoices, :assignment_id
    rename_column :invoices, :assignment_id, :engagement_id
    add_index :invoices, :engagement_id
  end
end
