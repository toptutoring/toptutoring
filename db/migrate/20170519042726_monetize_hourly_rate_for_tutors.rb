class MonetizeHourlyRateForTutors < ActiveRecord::Migration[5.0]
  def up
    default_rate = 1500
    change_column :contracts, :hourly_rate, :integer, null: false, default: default_rate
    add_monetize :contracts, :hourly_rate, amount: { default: default_rate }
  end

  def down
    change_column :contracts, :hourly_rate, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    remove_column :contracts, :hourly_rate_cents
    remove_column :contracts, :hourly_rate_currency
  end
end
