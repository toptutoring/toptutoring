class DropOutstandingBalanceFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_columns :users, :outstanding_balance
  end

  def down
    add_column :users, :outstanding_balance, :decimal, precision: 10, scale: 2
  end
end
