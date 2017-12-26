class PaymentService
  Result = Struct.new(:success?, :message)

  def initialize(user, academic_type, hours)
    @user = user
    @academic_type = academic_type
    @hours = hours
  end

  def charge!(stripe_obj)
    payment = build_payment(stripe_obj)
    process_payment!(payment, stripe_obj)
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe Payment Error for #{user.name + user.id.to_s}: " + e.message)
    Result.new(false, "There was an error submitting payment with your credit card.")
  end

  private

  attr_reader :user, :academic_type, :hours

  def build_payment(stripe_obj)
    Payment.new(
      amount_cents: amount_in_cents,
      description:  payment_description,
      status:       "succeeded",
      customer_id:  stripe_obj.stripe_token,
      payer:        user,
      created_at:   Time.now,
      last_four:    stripe_obj.last_four,
      card_brand:   stripe_obj.card_brand
    )
  end

  def process_payment!(payment, stripe_obj)
    if payment.valid? && user_credit_valid
      charge = charge_with_stripe(stripe_obj.stripe_token)
      payment.stripe_charge_id = charge.id
      payment.save
      user.save
      send_notices(payment)
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

  def send_notices(payment)
    args = [@user, @academic_type, @hours, payment]
    UserNotifierMailer.send_payment_notice(*args)
                      .deliver_later
    SlackNotifier.notify_payment_made(payment)
  end
end
