class RenameAssignmentsToEngagements < ActiveRecord::Migration[5.0]
  def change
    rename_table :assignments, :engagements
  end
end
