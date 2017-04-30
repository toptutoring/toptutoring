class RemoveBalanceFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :balance
  end
end
