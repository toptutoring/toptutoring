class UpdateRolesColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :students, :name, :string
    change_column :students, :email, :string
    change_column :tutors, :subject, :string
  end
end
