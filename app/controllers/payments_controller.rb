class PaymentsController < ApplicationController
  before_action :require_login

  def new
    @payment = Payment.new
    @feedback = current_user.feedbacks.build
    @student_engagements = get_student_engagements
    @invoices = []
    @total_suggested_hours = 0

    @student_engagements.each do |engagement|
      invoices = Invoice.where(engagement_id: engagement.id)
      if invoices.count == 1
        if invoices.first.status != "paid"
          @invoices << invoices.first
          @total_suggested_hours += engagement.suggestions.last.suggested_minutes/60.0 unless engagement.suggestions.empty?
        end
      end
    end
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
    payment_service = PaymentService.new(current_user.id, amount_in_cents, 'usd', nil, payment_params)

    if current_user.customer_id.empty?
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

  def payment_params
    params.require(:payment).permit(:description, :hours, :academic_type)
  end

  private

  def get_student_engagements
    if current_user.is_student?
      current_user.student_engagements
    else
      current_user.client_engagements
    end
  end

  def feedback_params
    params.require(:feedback).permit(:comments)
  end

  def amount_in_cents
    (params[:amount].to_f * 100).to_i
  end
end
