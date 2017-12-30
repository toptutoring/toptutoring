class UserNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def send_signup_email(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end

  def send_payment_notice(user, card_holder_name, academic_type, hours, payment)
    @user = user
    @card_holder_name = card_holder_name
    @academic_type = academic_type
    @hours = hours
    @payment = payment
    @rate = user_rate
    mail(to: @user.email,
         subject: "You have made a purchase")
  end

  private

  def user_rate
    return @user.academic_rate if @academic_type == "academic"
    @user.test_prep_rate
  end
end
