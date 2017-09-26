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
    payment_service = PaymentService.new(current_user.id, amount_in_cents, 'usd', token, one_time_payment_params)

    begin
      if params[:save_payment_info] && current_user
        payment_service.save_payment_info
        payment = payment_service.create_charge
      else
        payment = payment_service.create_charge
      end

      payment_service.process!(payment) if current_user
      redirect_to confirmation_path
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      render :new
    end
  end

  private

  def one_time_payment_params
    params.require(:payment).permit(:description, :hours, :academic_type)
  end

  def amount_in_cents
    params[:amount].to_money.cents
  end
end
