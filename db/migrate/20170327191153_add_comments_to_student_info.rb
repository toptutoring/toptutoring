class AddCommentsToStudentInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :client_infos, :comments, :string
  end
end
