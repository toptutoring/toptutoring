class OneTimePaymentsController < ApplicationController
  layout "authentication"

  if Rails.env.production?
    force_ssl(host: ENV['SSL_APPLICATION_HOST'])
  end

  def confirmation
  end

  def create
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
    token = params[:stripeToken]
    @amount = params[:payments][:amount]
    @amount = Float(@amount).round(2)
    @amount = (@amount * 100).to_i

    begin
      if params[:save_payment_info] && current_user
        customer = Stripe::Customer.create(
          source: token,
          email: current_user.email)

        current_user.customer_id = customer.id
        current_user.save!
        payment = Stripe::Charge.create(
          amount: @amount,
          currency: 'usd',
          customer: current_user.customer_id,
          description: params[:payments][:description])
      else
        payment = Stripe::Charge.create(
          amount: @amount,
          currency: 'usd',
          source: token,
          description: params[:payments][:description])
      end

      if current_user
        PaymentService.new.perform(payment, current_user.id)
      end

      redirect_to confirmation_path
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end
end
