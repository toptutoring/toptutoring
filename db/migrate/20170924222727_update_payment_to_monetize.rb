class UpdatePaymentToMonetize < ActiveRecord::Migration[5.1]
  def change
    rename_column :payments, :amount_in_cents, :amount_cents
  end
end
