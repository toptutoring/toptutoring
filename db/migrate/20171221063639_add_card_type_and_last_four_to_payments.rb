class AddCardTypeAndLastFourToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :card_brand, :string
    add_column :payments, :last_four, :string
    add_column :payments, :stripe_charge_id, :string
  end
end
