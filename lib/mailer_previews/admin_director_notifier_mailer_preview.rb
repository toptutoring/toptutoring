class AdminDirectorNotifierMailerPreview < ActionMailer::Preview
  def new_user_registered
    subject = Struct.new(:name).new("Math")
    client_info = Struct.new(:subject, :comments)
                        .new(subject, nil)
    client = Struct.new(:phone_number, :email, :name, :created_at, :signup)
                   .new("510-555-5555", "client@example.com", "Client", Time.current, client_info)
    AdminDirectorNotifierMailer.new_user_registered(client)
  end
end
