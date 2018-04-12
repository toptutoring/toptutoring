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
    invoice = Struct.new(:created_at, :submitter, :hours, :subject, :online, :hours_type)
                    .new(Time.current, tutor, 1.75, "English", true, "online_test_prep")
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
end
