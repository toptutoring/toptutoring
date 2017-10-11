class PaymentService
  attr_reader :customer

  def initialize(user_id, amount_in_cents, currency, token, params)
    @user = User.find(user_id)
    @description = params[:description]
    @amount_in_cents = amount_in_cents
    @currency = currency
    @token = token
    @hours = params[:hours].to_f
    @academic_type = params[:academic_type]
    @customer = retrieve_customer
  end

  def retrieve_customer
    if @token.nil?
      Stripe::Customer.retrieve @user.customer_id
    else
      Stripe::Customer.create(
        source: @token,
        email: @user.email
      )
    end
  end

  def create_charge
    payment = Stripe::Charge.create(
      amount: @amount_in_cents,
      currency: @currency,
      customer: @customer,
      description: @description
    )
  end

  def save_payment_info
    @user.customer_id = @customer.id
    @user.save
  end

  def process!(payment)
    if new_payment = create_payment(payment, @user.id)
      update_client_credit(new_payment.amount_cents, @user.id, @academic_type) if new_payment.valid?
    end
  end

  private

  def create_payment(payment, payer_id)
    Payment.create(
      amount_cents: payment.amount,
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
