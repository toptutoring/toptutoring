class PaymentService
  Result = Struct.new(:success?, :message)

  def initialize(user, academic_type, hours)
    @user = user
    @academic_type = academic_type
    @hours = hours
  end

  def charge!(token)
    payment = build_payment(token)
    process_payment!(payment, token)
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe Payment Error for #{user.name + user.id.to_s}: " + e.message)
    Result.new(false, "There was an error submitting payment with your credit card.")
  end

  private

  attr_reader :user, :academic_type, :stripe_token, :hours

  def build_payment(token)
    Payment.new(
      amount_cents: amount_in_cents,
      description:  payment_description,
      status:       "succeeded",
      customer_id:  token,
      payer:        user,
      created_at:   Time.now
    )
  end

  def process_payment!(payment, token)
    if payment.valid? && user_credit_valid
      charge_with_stripe(token)
      payment.save
      user.save
      SlackNotifier.notify_payment_made(payment)
      Result.new(true, I18n.t('app.payment.success'))
    else
      Result.new(false, payment.errors.full_messages)
    end
  end

  def user_credit_valid
    if academic?
      user.academic_credit += hours
    else
      user.test_prep_credit += hours
    end
    user.valid?
  end

  def charge_with_stripe(token)
    Stripe::Charge.create(
      amount: amount_in_cents,
      currency: "usd",
      source: token,
      description: payment_description
    )
  end

  def amount_in_cents
    return @amount_cents if @amount_cents
    rate = academic? ? user.academic_rate : user.test_prep_rate
    @amount_cents = (hours * rate).cents
  end

  def payment_description
    @payment_desctiprion ||= "Purchase of #{hours_string}"
  end

  def hours_string
    type = academic? ? "Academic" : "Test Prep"
    hours.to_s + " " + type + " " + (hours == 1 ? "hour" : "hours.")
  end

  def academic?
    academic_type == "academic"
  end
end
