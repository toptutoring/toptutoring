class TutorMailer < ActionMailer::Base

  def send_mail(email)
    @email = email
    @receiver = @email.client.email
    mail(from: ENV['MAILER_SENDER'], to: @receiver, subject: @email.subject)
  end
end
