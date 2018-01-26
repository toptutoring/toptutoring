class Clients::PaymentsController < ApplicationController
  before_action :require_login, :check_for_engagements

  def new
    @hours_type_options = []
    @hours_type_options << ["Online Academic Hours", "online_academic"] if current_user.online_academic_rate > 0
    @hours_type_options << ["Online Test Prep Hours", "online_test_prep"] if current_user.online_test_prep_rate > 0
    @hours_type_options << ["In-Person Academic Hours", "in_person_academic"] if current_user.in_person_academic_rate > 0
    @hours_type_options << ["In-Person Test Prep Hours", "in_person_test_prep"] if current_user.in_person_test_prep_rate > 0
    @account = current_user.stripe_account
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    source = determine_source
    results = PaymentService.new(source, payment_params, account).charge!
    if results.success?
      flash.notice = results.message
      redirect_to clients_payments_path
    else
      flash.alert = results.message
      redirect_to action: :new
    end
  end

  private

  def determine_source
    return current_user.stripe_account.default_source_id if use_existing_card?
    return token_id unless save_card_info?
    result = StripeAccountService.create_account!(current_user, token_id)
    result.source
  end

  def payment_params
    params.require(:payment)
          .permit(:hours_purchased, :hours_type)
          .merge(payer_id: current_user.id)
  end

  def use_existing_card?
    params[:use_existing_card] == "true"
  end

  def token_id
    params.require(:stripe_token)
  end

  def save_card_info?
    params[:save_card_information] == "true"
  end

  def account
    current_user.stripe_account
  end

  def check_for_engagements
    return if current_user.client_account.engagements.active.any?
    flash.notice = I18n.t("app.clients.payments.no_engagements")
    redirect_to dashboard_path
  end
end
