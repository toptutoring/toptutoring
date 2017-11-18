class SetStudentPasswordMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def set_password(user_id)
    @user = User.find(user_id)
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end
end
