class NewClientNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def started_sign_up(new_user)
    @new_user = new_user
    @users = User.admin_and_directors
    @users.each do |user|
      @user = user
      mail(to: @user.email,
           subject: "#{@new_user.name} has begun the signup process as a client")
    end
  end

  def finished_sign_up(new_user)
    @new_user = new_user
    @users = User.admin_and_directors
    @users.each do |user|
      @user = user
      mail(to: @user.email,
           subject: "#{@new_user.name} has just finished the signup process as a client")
    end
  end
end
