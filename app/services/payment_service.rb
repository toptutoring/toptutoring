class PaymentService
  Result = Struct.new(:success?, :message)

  def initialize(payment_params, token)
    @user = User.find(payment_params[:payer_id])
    @payment_params = payment_params
    @token = token
  end

  def charge!
    payment = build_payment
    process_payment!(payment)
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe payment error for #{user.name + user.id.to_s}: " + e.message)
    Result.new(false, I18n.t("app.payment.failure"))
  end

  private

  attr_reader :user, :payment_params

  def build_payment
    payment = Payment.new(payment_params)
    payment.assign_attributes(description: payment_description,
                              status: "succeeded", amount: amount, rate: rate)
    payment
  end

  def amount
    hours * rate
  end

  def hours
    @hours ||= payment_params[:hours_purchased].to_f
  end

  def academic_type
    @academic_type ||= payment_params[:hours_type]
  end

  def rate
    if academic_type == "academic"
      user.academic_rate
    elsif academic_type == "test_prep"
      user.test_prep_rate
    end
  end

  def payment_description
    "Purchase of #{hours} #{academic_type.humanize} hours."
  end

  def process_payment!(payment)
    if payment.valid? && user_credit_valid
      charge = charge_with_stripe(payment)
      payment.stripe_charge_id = charge.id
      payment.save
      user.save
      send_notices(payment)
      Result.new(true, I18n.t("app.payment.success"))
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
      source: @token,
      description: payment.description
    )
  end

  def academic?
    academic_type == "academic"
  end

  def send_notices(payment)
    UserNotifierMailer.send_payment_notice(user, payment)
                      .deliver_later
    SlackNotifier.notify_client_payment(payment)
  end
end
