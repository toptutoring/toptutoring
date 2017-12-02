class AdminDirectorNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def new_user_started_sign_up(new_user)
    @new_user = new_user
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@new_user.name} has begun the signup process as a client")
  end

  def new_user_finished_sign_up(new_user)
    @new_user = new_user
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@new_user.name} has just finished the signup process as a client")
  end
end
