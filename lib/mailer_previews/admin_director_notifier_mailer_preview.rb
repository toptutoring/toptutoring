class AdminDirectorNotifierMailerPreview < ActionMailer::Preview
  def new_user_registered
    subject = Struct.new(:name).new("Math")
    client_info = Struct.new(:subject, :comments)
                        .new(subject, nil)
    client = Struct.new(:phone_number, :email, :name, :created_at, :signup)
                   .new("510-555-5555", "client@example.com", "Client", Time.current, client_info)
    AdminDirectorNotifierMailer.new_user_registered(client)
  end

  def notify_review_made
    client = Struct.new(:name).new("Client")
    review = Struct.new(:stars, :review).new(5, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt5, \"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"in culpa qui officia deserunt mollit anim id est laborum.")
    AdminDirectorNotifierMailer.notify_review_made(client, review)
  end
end
