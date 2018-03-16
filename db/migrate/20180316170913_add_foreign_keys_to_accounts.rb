class AddForeignKeysToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :invoices, :users, column: :submitter_id
  end
end
