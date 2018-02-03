class Clients::PaymentsController < ApplicationController
  before_action :require_login, :check_for_engagements

  def new
    @hours_type_options = []
    @hours_type_options << ["Online Academic Hours", "online_academic"] if current_user.online_academic_rate > 0
    @hours_type_options << ["Online Test Prep Hours", "online_test_prep"] if current_user.online_test_prep_rate > 0
    @hours_type_options << ["In-Person Academic Hours", "online_academic"] if current_user.in_person_academic_rate > 0
    @hours_type_options << ["In-Person Test Prep Hours", "in_person_test_prep"] if current_user.in_person_test_prep_rate > 0
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
    return if current_user.client_account.engagements.active.any?
    flash.notice = I18n.t("app.clients.payments.no_engagements")
    redirect_to dashboard_path
  end
end
