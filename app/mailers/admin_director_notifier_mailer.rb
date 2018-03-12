class AdminDirectorNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def new_user_registered(new_user)
    @new_user = new_user
    @phone = Phonelib.parse(new_user.phone_number, :us).national
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@new_user.full_name} has registered as a client")
  end

  def notify_review_made(user, review)
    @user = user
    @review = review
    users = User.admin_and_directors
    mail(to: "noreply@toptutoring.com",
         bcc: users.map(&:email),
         subject: "#{@user.full_name} has submitted a review of #{@review.stars} stars")
  end
end
