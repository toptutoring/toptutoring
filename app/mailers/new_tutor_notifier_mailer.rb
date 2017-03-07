class NewTutorNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.org'

  def welcome(new_user, users)
    @new_user = new_user
    @users = users
    @users.each do |user|
      @user = user
      mail(to: @user.email,
           subject: "#{@new_user.name} has just registered")
    end
  end
end
