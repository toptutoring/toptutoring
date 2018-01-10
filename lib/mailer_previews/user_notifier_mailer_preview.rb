class UserNotifierMailerPreview < ActionMailer::Preview
  def send_signup_email
    client = Struct.new(:email, :name).new("client@example.com", "Client")
    UserNotifierMailer.send_signup_email(client)
  end

  def send_payment_notice
    client = Struct.new(:email).new("client@example.com")
    payment = Struct.new(:created_at, :amount, :rate,
                         :card_brand_and_four_digits, :card_holder_name,
                         :hours_type, :hours_purchased)
                    .new(Time.current, "24.99", "24.99", "Visa ending in 1234",
                         "Client", "test_prep", "1.0")
    UserNotifierMailer.send_payment_notice(client, payment)
  end
end
