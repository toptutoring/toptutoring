class NewTutorNotifierMailerPreview < ActionMailer::Preview
  def mail_admin_and_directors
    tutor = Struct.new(:email, :full_name, :created_at).new("tutor@example.com", "Tutor", Time.current)
    NewTutorNotifierMailer.mail_admin_and_directors(tutor)
  end
end
