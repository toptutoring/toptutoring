class RemoveStudentInfo < ActiveRecord::Migration[5.1]
  def change
    drop_table :student_infos
  end
end
