class DataMigrationForStudentAccounts < ActiveRecord::Migration[5.1]
  def up
    user = User.find_by(id: 89, email: "jlety@hotmail.com")
    student_account = user.student_account
    student_account.user_id = nil
    if student_account.save
      STDOUT.puts "Student Account #{student_account.id} for User #{user.id} has been updated."
    else
      STDOUT.puts "Unable to update Student Account #{student_account.id} for User #{user.id}."
    end
  end
end
