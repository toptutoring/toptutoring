class SetStudentPasswordMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def mail_student(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end
end
