class AddOutStandingBalanceToUsers < ActiveRecord::Migration[5.0]
  def change
  add_column :users, :out_standing_balance, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
