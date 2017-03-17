class SetStudentPasswordMailer < ApplicationMailer
  default from: 'tutor@toptutoring.org'

  def set_password(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end
end
