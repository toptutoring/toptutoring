class Clients::PaymentsController < ApplicationController
  before_action :require_login, :check_for_engagements

  def new
    @hours_type_options = current_user.client_account
                                      .academic_types_engaged
                                      .map do |type|
                                        ["#{type.titlecase} Hours", type]
                                      end
    @account = current_user.stripe_account
    @payments = Payment.from_user(current_user.id)
  end

  def create
    results = PaymentService.new(source, payment_params, account).charge!
    if results.success?
      redirect_to({ action: :confirmation }, notice: results.message)
    else
      flash.alert = results.message
      redirect_to action: :new
    end
  end

  def confirmation
    @payment = current_user.payments_made.last
  end

  private

  def source
    return params.require(:card_id) unless use_new_card?
    return token_id unless save_card_info?
    result = StripeAccountService.create_account!(current_user, token_id)
    result.source
  end

  def payment_params
    params.require(:payment)
          .permit(:hours_purchased, :hours_type)
          .merge(payer_id: current_user.id)
  end

  def use_new_card?
    params[:use_new_card] == "true"
  end

  def token_id
    params.require(:stripe_token)
  end

  def save_card_info?
    params[:save_card_information] == "true"
  end

  def account
    return nil if use_new_card? && !save_card_info?
    current_user.stripe_account
  end

  def check_for_engagements
    return if current_user.client_account.engagements.active.any?
    flash.notice = I18n.t("app.clients.payments.no_engagements")
    redirect_to dashboard_path
  end
end
