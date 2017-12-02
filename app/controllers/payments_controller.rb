class PaymentsController < ApplicationController
  before_action :require_login
  before_action :set_stripe_key, only: :create

  def new
    @payment = Payment.new
    @academic_types = current_user.client_account.academic_types_engaged
    @total_suggested_time = set_suggested_time
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    if current_user.client_account.engagements.many?
      Bugsnag.notify("More than one engagement. Handle this payment case")
    else
      engagement = current_user.client_account.engagements.last
      if engagement.academic?
        rate = current_user.academic_rate
      else
        rate = current_user.test_prep_rate
      end
    end

    amount_in_cents = payment_params[:hours].to_i * rate.cents
    @payment_service = PaymentService.new(current_user.id, amount_in_cents, 'usd', params[:stripeToken], payment_params)
    payment_record = process_stripe_payment
    @payment_service.save_payment_info if params[:save_payment_info]
    SlackNotifier.notify_payment_made(payment_record)
    redirect_back(fallback_location: (request.referer || root_path))
  end

  def first_session_payment
    @engagement = Engagement.find(params[:engagement])
    respond_to do |format|
      format.js { render :file => 'payments/first_session_payment.js.erb' }
    end
  end

  def low_balance_payment
    @engagement = Engagement.find(params[:engagement])
    @count = params[:count]

    respond_to do |format|
      format.js { render :file => 'payments/low_balance_payment.js.erb' }
    end
  end

  def get_user_feedback
    @feedback = current_user.feedbacks.build(feedback_params)
    if (@feedback_saved = @feedback.save)
      flash.now[:notice] = "Your feedback has been received and we will reach out to you as soon as possible. Thank you!"
    else
      flash.now[:danger] = "There was an error handling your feedback. Try again later."
    end

    respond_to do |format|
      format.js { render :file => 'payments/process_user_feedback.js.erb' }
    end
  end

  private

  def process_stripe_payment
    if @payment_service.customer.nil?
      flash[:danger] = "You must provide your card information before making a payment."
    elsif charge_customer
      @payment_service.process!(@payment)
    end
  end

  def charge_customer
    @payment = @payment_service.create_charge
    flash[:notice] = 'Payment successfully made.'
  rescue Stripe::CardError => e
    flash[:danger] = e.message
    return false
  end

  def payment_params
    params.require(:payment).permit(:description, :hours, :academic_type)
  end

  def feedback_params
    params.require(:feedback).permit(:comments)
  end

  def set_stripe_key
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
  end

  def set_suggested_time
    return nil unless current_user.client_account.suggestions
    suggested_minutes = current_user.client_account.suggestions.pending.sum(:suggested_minutes)
    hours = suggested_minutes / 60
    remainder_minutes = suggested_minutes % 60
    time_string = "#{hours} #{'hour'.pluralize(hours)}"
    time_string += " and #{remainder_minutes} minutes" unless remainder_minutes.zero?
    time_string
  end
end
