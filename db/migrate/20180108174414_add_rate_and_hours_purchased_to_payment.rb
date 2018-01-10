class AddRateAndHoursPurchasedToPayment < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :rate_cents, :integer
    add_column :payments, :hours_type, :string
    add_column :payments, :card_holder_name, :string
    add_column :payments, :hours_purchased, :decimal, precision: 10, scale: 2
  end
end
