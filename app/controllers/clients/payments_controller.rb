class Clients::PaymentsController < ApplicationController
  before_action :require_login, :check_for_engagements

  def new
    @academic_types = current_user.client_account.academic_types_engaged
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    service = PaymentService.new(payment_params, token)
    results = service.charge!
    if results.success?
      flash.notice = results.message
      redirect_to clients_payments_path
    else
      flash.alert = results.message
      redirect_to action: :new
    end
  end

  def payment_params
    params.require(:payment)
          .permit(:hours_purchased, :hours_type,
                  :last_four, :card_holder_name, :card_brand)
          .merge(payer_id: current_user.id)
  end

  def token
    params.require(:stripe_token)
  end

  def check_for_engagements
    return if current_user.client_account.engagements.any?
    flash.notice = I18n.t("app.clients.payments.no_engagements")
    redirect_to dashboard_path
  end
end
