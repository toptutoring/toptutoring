class PaymentsController < ApplicationController
  before_action :require_login

  def new
    if !current_user.is_customer?
      redirect_to one_time_payment_path
    end
    @payment = Payment.new
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
    @amount = payment_params[:amount].extract_value
    payment_service = PaymentService.new(current_user.id, @amount, 'usd', nil, payment_params)

    if current_user.credit_cards.empty?
      flash[:danger] = "You must provide your card information before making a payment."
      render :new
    else
      begin
        payment = payment_service.create_charge_with_customer
        payment_service.process!(payment)
        flash[:notice] = 'Payment successfully made.'
        redirect_back(fallback_location: (request.referer || root_path))
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        render :new
      end
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:hours, :amount, :description, :academic_type)
  end
end
