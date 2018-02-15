class PaymentService
  Result = Struct.new(:success?, :message)

  def initialize(source, payment_params, account = nil)
    @user = User.find(payment_params[:payer_id])
    @payment_params = payment_params
    # source must be a valid Stripe source, i.e. "tok_xxxx", or "card_xxxx"
    @source = source
    @account = account
  end

  def charge!
    return Result.new(false, I18n.t("app.payment.failure")) unless source
    payment = build_payment
    process_payment!(payment)
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe payment error for #{user.name + user.id.to_s}: " + e.message)
    Result.new(false, I18n.t("app.payment.failure"))
  end

  private

  attr_reader :user, :payment_params, :source, :account

  def build_payment
    payment = Payment.new(payment_params)
    payment.assign_attributes(description: payment_description,
                              status: "succeeded", amount: amount, rate: rate,
                              stripe_account: account)
    payment
  end

  def amount
    (hours * rate.to_f * 100).round / 100.00
  end

  def hours
    @hours ||= payment_params[:hours_purchased].to_f
  end

  def hours_type
    @hours_type ||= payment_params[:hours_type]
  end

  def rate
    if hours_type == "online_academic"
      user.online_academic_rate
    elsif hours_type == "online_test_prep"
      user.online_test_prep_rate
    elsif hours_type == "in_person_academic"
      user.in_person_academic_rate
    elsif hours_type == "in_person_test_prep"
      user.in_person_test_prep_rate
    end
  end

  def payment_description
    "Purchase of #{hours} #{hours_type.humanize} hours."
  end

  def process_payment!(payment)
    if payment.valid? && user_credit_valid
      charge = charge_with_stripe(payment)
      add_stripe_charge_data(payment, charge)
      payment.save
      user.save
      send_notices(payment)
      Result.new(true, I18n.t("app.payment.success"))
    else
      Result.new(false, payment.errors.full_messages)
    end
  end

  def add_stripe_charge_data(payment, charge)
    payment.stripe_charge_id = charge.id
    card = charge.source
    payment.assign_attributes(stripe_source: card.id, last_four: card.last4,
                              card_holder_name: card.name,
                              card_brand: card.brand)
  end

  def user_credit_valid
    if hours_type == "online_academic"
      user.online_academic_credit += hours
    elsif hours_type == "online_test_prep"
      user.online_test_prep_credit += hours
    elsif hours_type == "in_person_academic"
      user.in_person_academic_credit += hours
    elsif hours_type == "in_person_test_prep"
      user.in_person_test_prep_credit += hours
    end
    user.valid?
  end

  def charge_with_stripe(payment)
    Stripe::Charge.create(
      stripe_charge_params(payment)
    )
  end

  def stripe_charge_params(payment)
    params = { amount: payment.amount_cents,
               currency: "usd",
               description: payment.description,
               source: source }
    params.merge!(customer: account.customer_id) if account
    params
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
