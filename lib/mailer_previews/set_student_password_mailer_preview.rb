class SetStudentPasswordMailerPreview < ActionMailer::Preview
  def mail_student
    client = Struct.new(:full_name).new("Client Name")
    student = Struct.new(:email, :full_name, :id, :confirmation_token, :client).new("student@example.com", "Student Name", 'id', 'token', client)
    SetStudentPasswordMailer.mail_student(student)
  end
end
