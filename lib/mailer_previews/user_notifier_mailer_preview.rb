class UserNotifierMailerPreview < ActionMailer::Preview
  def send_signup_email
    client = Struct.new(:email, :name).new("client@example.com", "Client")
    UserNotifierMailer.send_signup_email(client)
  end

  def send_payment_notice
    client = Struct.new(:email, :name, :academic_rate).new("client@example.com", "Client", Money.new(2499))
    payment = Struct.new(:created_at, :amount, :card_brand_and_four_digits).new(Time.now, "24.99", "Visa ending in 1234")
    UserNotifierMailer.send_payment_notice(client, "Card Holder", "academic", "1", payment)
  end
end
