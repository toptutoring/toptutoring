class AdminDirectorNotifierMailerPreview < ActionMailer::Preview
  def new_user_registered
    subject = Struct.new(:name).new("Math")
    client_info = Struct.new(:subject, :comments)
                        .new(subject, nil)
    client = Struct.new(:phone_number, :email, :full_name, :created_at, :signup, :country_code)
                   .new("510-555-5555", "client@example.com", "Client", Time.current, client_info, "us")
    AdminDirectorNotifierMailer.new_user_registered(client)
  end

  def notify_review_made
    client = Struct.new(:full_name).new("Client")
    review = Struct.new(:stars, :review).new(5, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt5, \"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"in culpa qui officia deserunt mollit anim id est laborum.")
    AdminDirectorNotifierMailer.notify_review_made(client, review)
  end

  def new_lead
    subject = Struct.new(:name).new("Math")
    lead = Struct.new(:phone_number, :email, :full_name, :created_at, :subject, :comments, :country_code, :zip)
                   .new("510-555-5555", "client@example.com", "Client", Time.current, subject, "I'm leaving a comment", "us", 94501)
    AdminDirectorNotifierMailer.new_lead(lead)
  end

  def new_tutor
    tutor = Struct.new(:email, :full_name, :created_at).new("tutor@example.com", "Tutor", Time.current)
    AdminDirectorNotifierMailer.new_tutor(tutor)
  end
end
