class ChangeNilClientIdInvoices < ActiveRecord::Migration[5.1]
  Rake::Task['update:correct_client_id_on_invoices'].invoke
end
