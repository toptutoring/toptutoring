class UserNotifierMailer < ApplicationMailer
  default bcc: -> { User.admin.email }
  helper PhoneNumberHelper

  def send_signup_email(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end

  def send_payment_notice(user, payment)
    @user = user
    @payment = payment
    mail(to: @user.email,
         subject: "You have made a purchase of #{@payment.hours_purchased} hours of tutoring")
  end

  def send_one_time_payment_notice(payment)
    @payment = payment
    mail(to: @payment.payer_email,
         subject: "You have made a one time payment of $#{@payment.amount} to Top Tutoring")
  end

  def send_invoice_notice(user, invoice)
    @user = user
    @invoice = invoice
    mail(to: @user.email,
         subject: "Summary of your tutoring session with #{@invoice.submitter.full_name} on #{l(invoice.session_date, format: :with_weekday)}")
  end

  def send_review_request(user)
    @user = user
    mail(to: user.email,
         subject: "We would appreciate your review and feedback!")
  end

  def send_referral_claimed_notice(referrer, referred)
    @referrer = referrer
    @rate_type = @referrer.client_account.highest_rate_type
    @current_credits = @referrer.send(@rate_type + "_credit")
    mail(to: referrer.email,
         subject: "Thank you for your referral!")
  end
end
