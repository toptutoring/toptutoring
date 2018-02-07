class AddPayoutToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_reference :invoices, :payout, foreign_key: true
  end
end
