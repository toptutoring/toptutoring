class SlackNotifier
  class << self
    CHANNELS = {
      development: "#testing",
      leads: "#leads",
      the_boss: "@tad",
      the_minion: "@ojameso",
      general: "#general"
    }.freeze

    def notify_user_signup_start(user)
      message = "A new user has signed up.\n" \
        "Name: #{user.name}\n" \
        "Phone Number: #{user.phone_number}\n" \
        "Email: #{user.email}\n" \
        "Comments: #{user.signup.comments}\n"
      ping(message, :leads)
    end

    def notify_user_signed_up(user)
      if user.persisted?
        message = "#{user.name} finished the sign up process.\n" \
          "Contact info for new client:\n" \
      else
        message = "#{user.name} attempted to finish sign up, but failed.\n" \
      end
      message.concat("Email: #{user.email}\nPhone Number: #{user.phone_number}")
      ping(message, :leads)
    end

    def notify_mass_payment_made(service)
      message = "A mass payment was attempted.\n"
      if service.messages.any?
        message += "Messages\n" + service.messages.join("\n")
      end
      if service.errors
        message += "Errors\n" + service.errors.join("\n")
      end
      ping(message, :general)
    end

    def notify_payment_made(payment)
      return unless payment.persisted?
      payer = payment.approver || payment.payer
      message = "A payment has been made.\n" \
        "By: #{payer.name}\n" \
        "Amount: #{payment.amount}"
      message.concat("\nTo: #{payment.payee.name}") if payment.payee
      ping(message, :general)
    end

    def notify_new_engagement(engagement)
      message = "#{engagement.client.name} has requested a new engagement.\n" \
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
