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
    @amount = params[:payment][:amount].extract_value
    payment_service = PaymentService.new(current_user.id, @amount, 'usd', params[:payment][:description], token, params[:payment][:hours])

    begin
      if params[:save_payment_info] && current_user
        customer = payment_service.retrieve_customer
        current_user.customer_id = customer.id
        current_user.save!
        payment = payment_service.create_charge_with_customer
      else
        payment = payment_service.create_charge_with_token
      end

      payment_service.process!(payment) if current_user
      redirect_to confirmation_path
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end
end
