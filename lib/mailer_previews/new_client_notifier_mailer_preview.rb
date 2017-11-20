class NewClientNotifierMailerPreview < ActionMailer::Preview
  def started_sign_up
    client_info = Struct.new(:subject, :comments)
                        .new("Math", nil)
    client = Struct.new(:email, :name, :created_at, :signup)
                   .new("client@example.com", "Client", Time.current, client_info)
    NewClientNotifierMailer.started_sign_up(client)
  end

  def finished_sign_up
    client_info = Struct.new(:subject, :comments).new("Math", nil)
    client = Struct.new(:email, :phone_number, :name, :created_at, :signup)
                   .new("client@example.com", "510-TOP-TUTR", "Client", Time.current, client_info)
    NewClientNotifierMailer.finished_sign_up(client)
  end
end
