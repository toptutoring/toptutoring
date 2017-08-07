class NewClientNotifierMailerPreview < ActionMailer::Preview
  def welcome
    client_info = Struct.new(:subject, :comments).new("Math", nil)
    client = Struct.new(:email, :name, :created_at, :client_info).new("client@example.com", "Client", Time.current, client_info, )
    admin = Struct.new(:email, :name).new("admin@example.com", "Admin")
    NewClientNotifierMailer.welcome(client, admin)
  end
end
