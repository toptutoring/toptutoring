class StudentMailerPreview < ActionMailer::Preview
  def set_password
    client = Struct.new(:full_name).new("Client Name")
    student = Struct.new(:email, :full_name, :id, :confirmation_token, :client).new("student@example.com", "Student Name", 'id', 'token', client)
    StudentMailer.set_password(student)
  end
end
