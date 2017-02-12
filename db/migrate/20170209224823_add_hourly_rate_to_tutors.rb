class AddHourlyRateToTutors < ActiveRecord::Migration[5.0]
  def change
    add_column :tutors, :hourly_rate, :decimal, precision: 10, scale: 2, default: 0, null: false
  end
end
