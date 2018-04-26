class UserNotifierMailerPreview < ActionMailer::Preview
  def send_signup_email
    client = Struct.new(:email, :full_name).new("client@example.com", "Client")
    UserNotifierMailer.send_signup_email(client)
  end

  def send_payment_notice
    client = Struct.new(:email, :online_test_prep_credit)
                   .new("client@example.com", 5.0)
    payment = Struct.new(:created_at, :amount, :rate,
                         :card_brand_and_four_digits, :card_holder_name,
                         :hours_type, :hours_purchased)
                    .new(Time.current, "24.99", "24.99", "Visa ending in 1234",
                         "Client", "online_test_prep", "1.0")
    UserNotifierMailer.send_payment_notice(client, payment)
  end

  def send_one_time_payment_notice
    payment = Struct.new(:created_at, :amount, :payer_email,
                         :card_brand_and_four_digits, :card_holder_name)
                    .new(Time.current, "100.00", "test@example.com",
                         "Visa ending in 1234", "Client Name")
    UserNotifierMailer.send_one_time_payment_notice(payment)
  end

  def send_invoice_notice
    client = Struct.new(:email, "online_test_prep_credit").new("client@example.com", 5.0)
    tutor = Struct.new(:full_name).new("Tutor")
    invoice = Struct.new(:created_at, :submitter, :hours, :subject, :online, :hours_type, :session_date, :description)
                    .new(Time.current, tutor, 1.75, "English", true, "online_test_prep", Date.current, lorem_ipsum)
    UserNotifierMailer.send_invoice_notice(client, invoice)
  end

  def send_review_request
    UserNotifierMailer.send_review_request(User.clients.last)
  end

  def send_referral_claimed_notice
    account = Struct.new(:highest_rate_type).new("online_test_prep")
    client = Struct.new(:email, :full_name, :client_account, :online_test_prep_credit)
                   .new("client@example.com", "Client Name", account, 3)
    UserNotifierMailer.send_referral_claimed_notice(client, User.clients.last)
  end

  private
  
  def lorem_ipsum
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end
end
