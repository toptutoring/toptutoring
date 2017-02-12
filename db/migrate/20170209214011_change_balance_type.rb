class ChangeBalanceType < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :balance, :decimal, precision: 10, scale: 2, default: 0, null: false
  end
end
