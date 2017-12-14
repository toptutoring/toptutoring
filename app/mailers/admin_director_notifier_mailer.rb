class AdminDirectorNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def new_user_registered(new_user)
    @new_user = new_user
    @phone = Phonelib.parse(new_user.phone_number, :us).national
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@new_user.name} has registered as a client")
  end
end
