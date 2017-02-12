class PaymentService

  def perform(payment, user_id)
    if payment = create_payment(payment, user_id)
      update_user_balance(payment.amount/100, user_id) if payment.valid?
    end
  end

  private

  def create_payment(payment, user_id)
    Payment.create(
      amount: payment.amount,
      description: payment.description,
      status: payment.status,
      customer_id: payment.customer,
      destination: payment.destination,
      payer_id: user_id,
      created_at: Time.now)
  end

  def update_user_balance(amount, user_id)
    UpdateUserBalance.new(amount, user_id).increase
  end
end
