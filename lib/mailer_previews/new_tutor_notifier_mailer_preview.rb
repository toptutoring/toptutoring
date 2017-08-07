class NewTutorNotifierMailerPreview < ActionMailer::Preview
  def welcome
    tutor = Struct.new(:email, :name, :created_at).new("tutor@example.com", "Tutor", Time.current)
    admin = Struct.new(:email, :name).new("admin@example.com", "Admin")
    NewTutorNotifierMailer.welcome(tutor, [admin])
  end
end
