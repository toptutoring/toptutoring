class SlackNotifier
  class << self
    CHANNELS = {
      development: "#testing",
      leads: "#leads",
      payments: "#payments",
      the_boss: "@tad",
      the_minion: "@ojameso",
      general: "#general"
    }.freeze

    def notify_user_signup_start(user)
      phone = Phonelib.parse(user.phone_number, user.country_code)
      message = "A new user has signed up.\n"
      message.concat lead_message(user, phone, user.signup.comments)
      ping(message, :leads)
    end

    def notify_new_lead(lead)
      phone = Phonelib.parse(lead.phone_number, lead.country_code)
      message = "A user has left their contact info.\n"
      message.concat("Lead failed to save. #{lead.errors.full_messages.join(", ")}") unless lead.persisted?
      return if !lead.persisted? && lead.comments.blank?# Skip even more spammers# && (lead.first_name == lead.last_name) # Skip spammers
      message.concat lead_message(lead, phone, lead.comments)
      ping(message, :leads)
    end

    def lead_message(lead, phone, comments)
      "Name: #{lead.full_name}\n" \
        "Phone Number: #{phone.national}\n" \
        "Email: #{lead.email}\n" \
        "Zip: #{lead.zip}\n" \
        "Comments: #{comments}\n"
    end

    def notify_mass_payment_made(payment_messages)
      message = "A mass payment was attempted."
      message += "\nMessages\n" + payment_messages.join("\n")
      ping(message, :payments)
    end

    def notify_client_payment(payment)
      return unless payment.persisted?
      payer = payment.payer
      accounts = payer.client_account.student_accounts
      message = "A payment has been made.\n" \
        "By: #{payer.full_name}\n" \
        "Student accounts: #{accounts.pluck(:name).join(', ')}\n" \
        "Payment method: #{payment.card_brand_and_four_digits}\n" \
        "Amount: #{payment.amount}"
      ping(message, :payments)
    end

    def notify_one_time_payment(payment)
      return unless payment.persisted?
      message = "A payment has been made.\n" \
        "Type: One Time Payment\n" \
        "Cardholder Name: #{payment.card_holder_name}\n" \
        "Payment method: #{payment.card_brand_and_four_digits}\n" \
        "Email: #{payment.payer_email}\n" \
        "Amount: #{payment.amount}"
      ping(message, :payments)
    end

    def notify_payout_made(payout)
      message = "A payment has been made.\n" \
        "By: #{payout.approver.full_name}\n" \
        "To: #{payout.receiving_account.user.full_name}\n" \
        "Amount: #{payout.amount}"
      ping(message, :payments)
    end

    def notify_new_engagement(engagement)
      message = "#{engagement.client.full_name} has requested a new engagement.\n" \
        "Student: #{engagement.student_name}\n" \
        "Subject: #{engagement.subject.name}"
      ping(message, :leads)
    end

    def ping(message, channel)
      SLACK_NOTIFIER.ping(message, channel: channel_finder(channel)) unless Rails.env.test?
    end

    private

    def channel_finder(channel)
      if ENV["DWOLLA_ENVIRONMENT"] == "production" && Rails.env.production?
        CHANNELS[channel]
      else
        CHANNELS[:development]
      end
    end
  end
end
