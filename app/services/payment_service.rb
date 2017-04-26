class PaymentService
  def initialize(user_id, amount, currency, description, token)
    @user_id = user_id
    @description = description 
    @amount = amount
    @currency = currency 
    @token = token
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
      amount: @amount,
      currency: @currency,
      customer: user.customer_id,
      description: @description
    )
  end

  def create_charge_with_token
    payment = Stripe::Charge.create(
      amount: @amount,
      currency: @currency,
      source: @token,
      description: @description
    )
  end 

  def process!(payment)
    if new_payment = create_payment(payment, user.id)
      update_client_credit(new_payment.amount/100, user.id, @description) if new_payment.valid?
    end
  end

  private 
  def user 
    @user = User.find(@user_id)
  end

  def create_payment(payment, payer_id)
    Payment.create(
      amount:       payment.amount,
      description:  payment.description,
      status:       payment.status,
      customer_id:  payment.customer,
      destination:  payment.destination,
      payer_id:     payer_id,
      created_at:   Time.now)
  end

  def update_client_credit(amount, payer_id, description)
    client = User.find(payer_id)
    if description.casecmp("Academic") == 0
      client.academic_credit += amount / MultiCurrencyAmount.from_cent(client.academic_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
    else
      client.test_prep_credit += amount / MultiCurrencyAmount.from_cent(client.test_prep_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
    end
    client.save
  end
end
