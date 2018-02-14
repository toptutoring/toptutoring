class UserNotifierMailer < ApplicationMailer
  default from: 'tutor@toptutoring.com'

  def send_signup_email(user)
    @user = user
    mail(to: @user.email,
         subject: "Welcome to Top Tutoring")
  end

  def send_payment_notice(user, payment)
    @payment = payment
    mail(to: user.email,
         subject: "You have made a purchase of #{@payment.hours_purchased} of tutoring")
  end

  def send_invoice_notice(user, invoice)
    @invoice = invoice
    mail(to: user.email,
         subject: "You were invoiced for a session with #{@invoice.submitter.name}")
  end
end
