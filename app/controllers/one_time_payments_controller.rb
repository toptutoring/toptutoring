class OneTimePaymentsController < ApplicationController
  if Rails.env.production?
    force_ssl(host: "toptutoring.herokuapp.com/payment")
  end

  def create
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]
    puts params
    puts token
    @amount = params[:payments][:amount]
    @amount = Float(@amount).round(2)
    @amount = (@amount * 100).to_i

    begin
      Stripe::Charge.create(
        :amount => @amount,
        :currency => 'usd',
        :source => params[:stripeToken],
        :description => params[:payments][:description])

      redirect_to confirmation_url(host: ENV['HOST'], protocol: "http")
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end
end
