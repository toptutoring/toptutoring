class ChangeActivityTypeColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :students, :activity_type, :academic_type
    rename_column :tutors, :activity_type, :academic_type
  end
end
