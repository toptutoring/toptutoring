class SetStudentPasswordMailerPreview < ActionMailer::Preview
  def set_password
    student = User.students.last
    student.update(confirmation_token: 'a_token')
    SetStudentPasswordMailer.set_password(student.id)
  end
end
