class RemoveHourlyRateFromEngagements < ActiveRecord::Migration[5.0]
  def change
    remove_column :engagements, :hourly_rate
  end
end
