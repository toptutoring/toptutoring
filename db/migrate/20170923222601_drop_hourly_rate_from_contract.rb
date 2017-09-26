class DropHourlyRateFromContract < ActiveRecord::Migration[5.1]
  def change
    remove_column :contracts, :hourly_rate
  end
end
