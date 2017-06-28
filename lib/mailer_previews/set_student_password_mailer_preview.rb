class SetStudentPasswordMailerPreview < ActionMailer::Preview
  def set_password
    client = Struct.new(:name).new("Client")
    student = Struct.new(:email, :name, :client, :confirmation_token).new('student@example.com', 'Student', client, 'xxx')
    SetStudentPasswordMailer.set_password(student)
  end
end
