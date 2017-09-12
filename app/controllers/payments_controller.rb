class PaymentsController < ApplicationController
  before_action :require_login
  before_action :set_stripe_key, only: :create

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

    select_correct_tutoring_type
  end

  def index
    @payments = Payment.from_user(current_user.id)
  end

  def create
    @payment_service = PaymentService.new(current_user.id, amount_in_cents, 'usd', params[:stripeToken], payment_params)
    process_stripe_payment
    @payment_service.save_payment_info if params[:save_payment_info]
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

  def set_stripe_key
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
  end

  def select_correct_tutoring_type
    if @student_engagements.one?
      academic = @student_engagements.last.academic_type == "Academic"
      @test_prep_selected = academic ? "" : "selected"
      @empty_selected = ""
    else
      @empty_selected = "selected"
    end
  end
end
