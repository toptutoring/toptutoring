class NewTutorNotifierMailerPreview < ActionMailer::Preview
  def welcome
    tutor = Struct.new(:email, :name).new("tutor@example.com", "Tutor")
    admin = Struct.new(:email, :name).new("admin@example.com", "Admin")
    NewTutorNotifierMailer.welcome(tutor, [admin])
  end
end
