class PaymentService
  Result = Struct.new(:success?, :message, :payment)

  def initialize(source, payment_params, account = nil)
    # source must be a valid Stripe source, i.e. "tok_xxxx", or "card_xxxx"
    @source = source
    @account = account
    @payment = Payment.new(payment_params)
  end

  def charge!
    return generic_failure unless source
    assign_attributes unless payment.one_time
    process_payment!
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe payment error for #{user_name}: " + e.message)
    generic_failure
  end

  private

  attr_reader :source, :account, :payment

  def generic_failure
    Result.new(false, I18n.t("app.payment.failure"))
  end

  def assign_attributes
    payment.set_rate
    payment.set_amount
    payment.set_default_description
    payment.stripe_account = account
  end

  def user
    @user ||= payment.one_time ? nil : payment.payer
  end

  def user_name
    user ? (user.full_name + user.id.to_s) : payment.payer_email
  end

  def hours
    @hours ||= payment.hours_purchased
  end

  def process_payment!
    if payment.valid? && user_credit_valid
      charge_with_stripe
      payment.save
      user.save unless payment.one_time
      send_notices
      Result.new(true, I18n.t("app.payment.success"), payment)
    else
      error = payment.valid? ? payment.errors : user.errors
      Result.new(false, error.full_messages, nil)
    end
  end

  def user_credit_valid
    return true if payment.one_time
    case payment.hours_type
    when "online_academic"
      user.online_academic_credit += hours
    when "online_test_prep"
      user.online_test_prep_credit += hours
    when "in_person_academic"
      user.in_person_academic_credit += hours
    when "in_person_test_prep"
      user.in_person_test_prep_credit += hours
    end
    user.valid?
  end

  def charge_with_stripe
    charge = Stripe::Charge.create(
      { amount: payment.amount_cents,
        currency: "usd",
        description: payment.description,
        source: source,
        transfer_group: "#{user.id}_#{user.first_name}_#{user.last_name}"
       }.tap do |hash|
          hash.merge!(customer: account.customer_id) if account
        end
    )
    payment.stripe_charge_id = charge.id
    card = charge.source
    payment.assign_attributes(stripe_source: card.id, last_four: card.last4,
                              card_holder_name: card.name,
                              card_brand: card.brand, status: "succeeded")
  end

  def send_notices
    if payment.one_time
      UserNotifierMailer.send_one_time_payment_notice(payment)
                        .deliver_later
      SlackNotifier.notify_one_time_payment(payment)
    else
      UserNotifierMailer.send_payment_notice(user, payment)
                        .deliver_later
      SlackNotifier.notify_client_payment(payment)
    end
  end
end
