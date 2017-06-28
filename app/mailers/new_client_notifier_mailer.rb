class NewClientNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.org'

  def welcome(new_user, notified_user)
    @new_user = new_user
    @user = notified_user
    mail(to: @user.email,
         subject: "#{@new_user.name} has just registered")
  end
end
