class UserNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.org'

  def send_signup_email(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end
end
