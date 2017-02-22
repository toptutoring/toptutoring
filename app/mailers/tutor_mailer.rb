class TutorMailer < ActionMailer::Base

  def perform(email_id)
    set_params(email_id) &&
    send_email
  end

  private

  def set_params(email_id)
    @email = ActiveRecord::Base::Email.find(email_id)
    @receiver = @email.parent.email
  end

  def send_email
    mail(from: ENV['MAILER_SENDER'], to: @receiver, subject: @email.subject)
  end
end
