class NewClientNotifier
  def self.perform(new_user, notified_users)
    notified_users.each do |notified_user|
      NewClientNotifierMailer.welcome(new_user, notified_user).deliver_now
    end
  end
end
