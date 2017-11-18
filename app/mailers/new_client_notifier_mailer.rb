class NewClientNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def mail_admin_and_directors(new_user)
    @new_user = new_user
    @users = User.admin_and_directors
    @users.each do |user|
      @user = user
      mail(to: @user.email,
           subject: "#{@new_user.name} has just registered as a client")
    end
  end
end
