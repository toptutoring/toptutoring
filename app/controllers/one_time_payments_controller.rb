class OneTimePaymentsController < ApplicationController
  before_action :require_login

  def create
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]
    @amount = params[:payments][:amount]
    @amount = Float(@amount).round(2)
    @amount = (@amount * 100).to_i

    begin
      customer = Stripe::Customer.create(
        source: token,
        email: current_user.email)

      current_user.customer_id = customer.id
      current_user.save

      payment = Stripe::Charge.create(
        amount: @amount,
        currency: 'usd',
        customer: current_user.customer_id,
        description: params[:payments][:description])

      Payment.create(
        amount: payment.amount,
        description: payment.description,
        status: payment.status,
        source: payment.customer,
        destination: payment.destination)

      redirect_to confirmation_path
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end
end
