class AddPreferredStartDateToEngagements < ActiveRecord::Migration[5.0]
  def change
    add_column :engagements, :preferred_start_date, :datetime
  end
end
