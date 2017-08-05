class PaymentService
  def initialize(user_id, amount_in_cents, currency, token, params)
    @user_id = user_id
    @description = params[:description]
    @amount_in_cents = amount_in_cents
    @currency = currency
    @token = token
    @hours = params[:hours].to_f
    @academic_type = params[:academic_type]
  end

  def retrieve_customer
    customer = if user.customer_id
                  Stripe::Customer.retrieve user.customer_id
               else
                  customer = Stripe::Customer.create(
                               source: @token,
                               email: user.email
                             )
               end
  end

  def create_charge_with_customer
    payment = Stripe::Charge.create(
      amount: @amount_in_cents,
      currency: @currency,
      customer: user.customer_id,
      description: @description
    )
  end

  def create_charge_with_token
    payment = Stripe::Charge.create(
      amount: @amount_in_cents,
      currency: @currency,
      source: @token,
      description: @description
    )
  end

  def process!(payment)
    if new_payment = create_payment(payment, user.id)
      update_client_credit(new_payment.amount_in_cents, user.id, @academic_type) if new_payment.valid?
    end
  end

  private
  def user
    @user = User.find(@user_id)
  end

  def create_payment(payment, payer_id)
    Payment.create(
      amount_in_cents: payment.amount,
      description:     payment.description,
      status:          payment.status,
      customer_id:     payment.customer,
      destination:     payment.destination,
      payer_id:        payer_id,
      created_at:      Time.now)
  end

  def update_client_credit(amount_cents, payer_id, academic_type)
    client = User.find(payer_id)
    if academic_type.casecmp("Academic") == 0
      client.academic_credit += @hours if payment_valid?(amount_cents, client.academic_rate)
    else
      client.test_prep_credit += @hours if payment_valid?(amount_cents, client.test_prep_rate)
    end
    client.save
  end

  def payment_valid?(amount_cents, rate)
    (@hours * rate.cents).round == amount_cents ? true : false
  end
end
