class RenameStudentsAndTutorsTables < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :students, :student_infos
    rename_table :tutors, :tutor_infos
  end

  def self.down
    rename_table :tutor_infos, :tutors
    rename_table :student_infos, :students
  end
end
