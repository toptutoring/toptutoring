class AddPayerEmailToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :payer_email, :string
    add_column :payments, :one_time, :boolean, default: false
  end
end
