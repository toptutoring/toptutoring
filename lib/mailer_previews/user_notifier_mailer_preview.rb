class UserNotifierMailerPreview < ActionMailer::Preview
  def send_signup_email
    client = Struct.new(:email, :name).new("client@example.com", "Client")
    UserNotifierMailer.send_signup_email(client)
  end
end
