class ChangeAmountToCentsInPayment < ActiveRecord::Migration[5.1]
  def up
    execute "UPDATE payments SET amount = amount * 100 WHERE customer_id IS NULL"
    rename_column :payments, :amount, :amount_in_cents
  end

  def down
    rename_column :payments, :amount_in_cents, :amount
    execute "UPDATE payments SET amount = amount / 100 WHERE customer_id IS NULL"
  end
end
