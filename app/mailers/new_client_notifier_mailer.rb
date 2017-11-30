class NewClientNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def started_sign_up(new_user)
    @new_user = new_user
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@new_user.name} has begun the signup process as a client")
  end

  def finished_sign_up(new_user)
    @new_user = new_user
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@new_user.name} has just finished the signup process as a client")
  end
end
