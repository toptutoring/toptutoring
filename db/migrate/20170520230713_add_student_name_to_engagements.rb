class AddStudentNameToEngagements < ActiveRecord::Migration[5.0]
  def change
    add_column :engagements, :student_name, :string
  end
end
