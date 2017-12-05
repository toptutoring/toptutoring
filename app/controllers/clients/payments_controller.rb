class Clients::PaymentsController < ApplicationController
  before_action :require_login

  def new
    @academic_types = current_user.client_account.academic_types_engaged
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    service = PaymentService.new(current_user, academic_type, hours)
    results = service.charge!(stripe_token)
    if results.success?
      flash.notice = results.message
      redirect_to clients_payments_path
    else
      flash.alert = results.message
      redirect_to action: :new
    end
  end

  def academic_type
    params.require(:academic_type)
  end

  def hours
    params.require(:hours_desired).to_f
  end

  def stripe_token
    params.require(:stripeToken)
  end
end
