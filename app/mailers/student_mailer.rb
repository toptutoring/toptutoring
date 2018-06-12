class StudentMailer < ApplicationMailer
  def set_password(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end
end
