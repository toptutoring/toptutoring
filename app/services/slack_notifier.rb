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
      message = "A new user has signed up.\n" \
        "Name: #{user.full_name}\n" \
        "Phone Number: #{user.phone_number}\n" \
        "Email: #{user.email}\n" \
        "Comments: #{user.signup.comments}\n"
      ping(message, :leads)
    end

    def notify_user_signed_up(user)
      if user.persisted?
        message = "#{user.full_name} finished the sign up process.\n" \
          "Contact info for new client:\n" \
      else
        message = "#{user.full_name} attempted to finish sign up, but failed.\n" \
      end
      message.concat("Email: #{user.email}\nPhone Number: #{user.phone_number}")
      ping(message, :leads)
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
