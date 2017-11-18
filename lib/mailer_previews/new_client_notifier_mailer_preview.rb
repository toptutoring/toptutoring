class NewClientNotifierMailerPreview < ActionMailer::Preview
  def mail_admin_and_directors
    client_info = Struct.new(:subject, :comments).new("Math", nil)
    client = Struct.new(:email, :name, :created_at, :signup).new("client@example.com", "Client", Time.current, client_info)
    NewClientNotifierMailer.mail_admin_and_directors(client)
  end
end
