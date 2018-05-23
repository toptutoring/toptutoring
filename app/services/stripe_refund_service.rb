class StripeRefundService
  attr_reader :payment, :refund, :client
  def initialize(payment, refund)
    @payment = payment
    @refund = refund
    @client = payment.payer
  end

  def process_refund!
    set_changes
    stripe_refund = create_refund
    refund.stripe_refund_id = stripe_refund.id
    save_changes
  rescue Stripe::StripeError => e
    Bugsnag.notify("Stripe Error: " + e.message)
    false
  end

  private

  def create_refund
    Stripe::Refund.create(
      charge: payment.stripe_charge_id,
      amount: refund.amount_cents,
      metadata: {
        reason: refund.reason
      }
    )
  end

  def set_changes
    payment.status = "refunded"
    set_credit_changes
  end

  def set_credit_changes
    case payment.hours_type
    when "online_academic"
      client.online_academic_credit -= refund.hours
    when "online_test_prep"
      client.online_test_prep_credit -= refund.hours
    when "in_person_academic"
      client.in_person_academic_credit -= refund.hours
    when "in_person_test_prep"
      client.in_person_test_prep_credit -= refund.hours
    end
  end

  def save_changes
    payment.save
    client.save
    refund.save
  end
end
