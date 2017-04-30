class RenameOutStandingBalanceOfUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :out_standing_balance, :outstanding_balance
  end
end
