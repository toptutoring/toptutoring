class PaymentsController < ApplicationController
  before_action :require_login

  def create
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @amount = params[:payments][:amount]
    @amount = Float(@amount).round(2)
    @amount = (@amount * 100).to_i

    if current_user.customer_id == nil
      flash[:danger] = "You must provide your card information before making a payment."
      render :new
    else
      begin
        Stripe::Charge.create(
          amount: @amount,
          currency: 'usd',
          customer: current_user.customer_id,
          description: params[:payments][:description])

        redirect_to confirmation_path
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        render :new
      end
    end
  end
end
