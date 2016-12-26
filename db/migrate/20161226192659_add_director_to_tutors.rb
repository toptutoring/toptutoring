class AddDirectorToTutors < ActiveRecord::Migration[5.0]
  def change
    add_column :tutors, :director, :boolean, default: false, null: false
  end
end
