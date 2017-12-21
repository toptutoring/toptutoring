class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :engagements, :client_accounts
    add_foreign_key :engagements, :student_accounts
    add_foreign_key :engagements, :subjects
    add_foreign_key :invoices, :engagements
    add_foreign_key :student_accounts, :client_accounts
    add_foreign_key :student_accounts, :users
    add_foreign_key :tutor_accounts, :users
  end
end
