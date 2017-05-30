class ChangeTutoringForToStudent < ActiveRecord::Migration[5.0]
  def change
    rename_column :client_infos, :tutoring_for, :student
    change_column :client_infos, :student, 'boolean USING CAST(student AS boolean)'
  end
end
