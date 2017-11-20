class SetStudentPasswordMailerPreview < ActionMailer::Preview
  def mail_student
    client = Struct.new(:name).new("Client")
    student = Struct.new(:email, :name, :id, :confirmation_token, :client).new("student@example.com", "Student", 'id', 'token', client)
    SetStudentPasswordMailer.mail_student(student)
  end
end
