class OneTimePaymentsController < ApplicationController
  before_action :authenticate_user!
  layout false
  if Rails.env.production?
    force_ssl(host: "toptutoring.herokuapp.com")
  end

  def create
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = params[:stripeToken]
    @amount = params[:payments][:amount]
    @amount = Float(@amount).round(2)
    @amount = (@amount * 100).to_i

    begin
      Stripe::Charge.create(
        :amount => @amount,
        :currency => 'usd',
        :source => token,
        :description => params[:payments][:description])

      flash[:success] = "Payment successfully completed!"
      redirect_to confirmation_url(host: ENV['HOST'], protocol: "http")
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      redirect_to confirmation_url(host: ENV['HOST'], protocol: "http")
    end
  end
end
