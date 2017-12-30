class PaymentService
  Result = Struct.new(:success?, :message)

  def initialize(user, purchase_params)
    @user = user
    @academic_type = purchase_params[:academic_type]
    @hours = purchase_params[:hours_desired].to_f
    @stripe_token = purchase_params[:stripe_token]
    @last_four = purchase_params[:last_four]
    @card_brand = purchase_params[:card_brand]
    @card_holder_name = purchase_params[:card_holder_name]
  end

  def charge!
    payment = build_payment
    process_payment!(payment)
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe Payment Error for #{user.name + user.id.to_s}: " + e.message)
    Result.new(false, "There was an error submitting payment with your credit card.")
  end

  private

  attr_reader :user, :academic_type, :hours, :stripe_token,
              :last_four, :card_brand

  def build_payment
    Payment.new(
      amount_cents: amount_in_cents,
      description:  payment_description,
      status:       "succeeded",
      customer_id:  stripe_token,
      payer:        user,
      last_four:    last_four,
      card_brand:   card_brand
    )
  end

  def amount_in_cents
    rate = academic? ? user.academic_rate : user.test_prep_rate
    (hours * rate).cents
  end

  def payment_description
    "Purchase of #{hours} #{academic_type} hours."
  end

  def process_payment!(payment)
    if payment.valid? && user_credit_valid
      charge = charge_with_stripe(payment)
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

  def charge_with_stripe(payment)
    Stripe::Charge.create(
      amount: payment.amount_cents,
      currency: "usd",
      source: stripe_token,
      description: payment.description
    )
  end

  def academic?
    academic_type == "academic"
  end

  def send_notices(payment)
    args = [user, @card_holder_name, academic_type, hours, payment]
    UserNotifierMailer.send_payment_notice(*args)
                      .deliver_later
    SlackNotifier.notify_client_payment(payment)
  end
end
