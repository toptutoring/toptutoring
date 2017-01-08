class OneTimePaymentsController < ApplicationController
  layout "authentication"

  if Rails.env.production?
    force_ssl(host: "toptutoring.herokuapp.com/payment")
  end

  def create
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
    token = params[:stripeToken]
    @amount = params[:payments][:amount]
    @amount = Float(@amount).round(2)
    @amount = (@amount * 100).to_i

    begin
      Stripe::Charge.create(
        amount: @amount,
        currency: 'usd',
        source: token,
        description: params[:payments][:description])

      redirect_to confirmation_path
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end
end
