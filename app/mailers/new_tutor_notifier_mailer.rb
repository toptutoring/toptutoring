class NewTutorNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def mail_admin_and_directors(new_user)
    @new_user = new_user
    users = User.admin_and_directors
    mail(bcc: users.map(&:email),
         subject: "#{@new_user.full_name} has just registered as a tutor")
  end
end
