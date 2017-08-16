class NewClientNotifier
  def self.perform(new_user, notified_users)
    notified_users.each do |notified_user|
      # This code is just for testing, remove after emails are being sent correctly
      begin
        NewClientNotifierMailer.welcome(new_user, notified_user).deliver_now
        Rails.logger.info "Mailer: Email has been sent to #{notified_user.email}"
      rescue => e
        Bugsnag.notify("#{e} email error for user #{notified_user.email}")
      end
    end
  end
end
