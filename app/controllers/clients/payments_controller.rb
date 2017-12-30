class Clients::PaymentsController < ApplicationController
  before_action :require_login, :check_for_engagements

  def new
    @academic_types = current_user.client_account.academic_types_engaged
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    service = PaymentService.new(current_user, purchase_params)
    results = service.charge!
    if results.success?
      flash.notice = results.message
      redirect_to clients_payments_path
    else
      flash.alert = results.message
      redirect_to action: :new
    end
  end

  def purchase_params
    params.require(:purchase).permit(:academic_type, :hours_desired,
                                     :stripe_token, :last_four,
                                     :card_holder_name, :card_brand)
  end

  def check_for_engagements
    return if current_user.client_account.engagements.any?
    flash.notice = I18n.t("app.clients.payments.no_engagements")
    redirect_to dashboard_path
  end
end
