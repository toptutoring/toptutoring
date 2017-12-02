class AdminDirectorNotifierMailerPreview < ActionMailer::Preview
  def new_user_started_sign_up
    client_info = Struct.new(:subject, :comments)
                        .new("Math", nil)
    client = Struct.new(:email, :name, :created_at, :signup)
                   .new("client@example.com", "Client", Time.current, client_info)
    AdminDirectorNotifierMailer.new_user_started_sign_up(client)
  end

  def new_user_finished_sign_up
    client_info = Struct.new(:subject, :comments).new("Math", nil)
    client = Struct.new(:email, :phone_number, :name, :created_at, :signup)
                   .new("client@example.com", "510-TOP-TUTR", "Client", Time.current, client_info)
    AdminDirectorNotifierMailer.new_user_finished_sign_up(client)
  end
end
