class RemoveColumnsFromStudentInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :student_infos, :name
    remove_column :student_infos, :email
    remove_column :student_infos, :phone_number
  end
end
