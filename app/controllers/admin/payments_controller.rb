module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_auth_tutor, only: :new
    before_action :set_funding_source, :validate_funding_source, :set_payee, :set_invoice, only: :create

    def index
      @client_payments = Payment.from_clients
      @tutor_payments = Payment.to_tutor
    end

    def new
      @payment = Payment.new
      @tutors = User.tutors
    end

    def create
      if payment_within_balance?
        create_payment
      else
        flash[:danger] = "This exceeds the maximum payment for this tutor.
          Please contact an administrator if you have any questions"
      end
      redirect_back fallback_location: dashboard_path
    end

    private

    def payment_within_balance?
      return true unless @invoice
      @payee = User.find(params[:payment][:payee_id])
      @payee.outstanding_balance >= @invoice.hours
    end

    def payment_params
      amount = params[:amount].to_money
      params.require(:payment)
            .permit(:source, :description, :payee_id, :payer_id)
            .merge(amount: amount, source: @funding_source.funding_source_id)
    end

    def create_payment
      @payment = Payment.new(payment_params)
      if @payment.valid?
        process_payment
      else
        flash[:danger] = @payment.errors.full_messages
      end
    end

    def process_payment
      @transfer = PaymentGatewayDwolla.new(@payment)
      @transfer.create_transfer
      if @transfer.error.nil?
        @payment.save!
        adjust_balances if @invoice
        flash.notice = "Payment is being processed."
      else
        flash[:danger] = @transfer.error
      end
    end

    def set_payee
      @payee = User.find(payment_params[:payee_id])
    end

    def set_invoice
      @invoice = Invoice.find(params[:invoice].to_i) if params[:invoice]
    end

    def set_funding_source
      @funding_source = FundingSource.last
    end

    def validate_funding_source
      return unless @funding_source.nil?
      flash[:danger] = "Funding source is not set. Please contact the administrator."
      redirect_back(fallback_location: dashboard_path)
    end

    def set_auth_tutor
      @tutors = User.tutors_with_external_auth
    end

    def adjust_balances
      CreditUpdater.new(@invoice).process_payment_of_invoice!
    end
  end
end
