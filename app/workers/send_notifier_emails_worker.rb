class SendNotifierEmailsWorker
  include Sidekiq::Worker

  def perform(new_user_id)
    new_user = User.find(new_user_id)
    UserNotifierMailer.send_signup_email(new_user).deliver_now
    NewClientNotifier.perform(new_user, User.admin_and_directors)
  end
end
