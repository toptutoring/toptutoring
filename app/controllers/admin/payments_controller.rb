module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_funding_source, :validate_funding_source, :set_invoice, :set_payee, only: :create
    
    def index
      @client_payments = Payment.from_clients
      @tutor_payments = Payment.to_tutor
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
      @payee.outstanding_balance >= @invoice.hours
    end

    def create_payment
      @payment = Payment.new(payment_params)
      if @payment.valid?
        process_payment
      else
        flash[:danger] = @payment.errors.full_messages
      end
    end

    def payment_params
      {
        description: @invoice.description,
        payee: @payee,
        source: @funding_source.funding_source_id,
        payer: current_user,
        amount: @invoice.submitter_pay
      }
    end

    def process_payment
      @transfer = PaymentGatewayDwolla.new(@payment)
      @transfer.create_transfer
      if @transfer.error.nil?
        @payment.save!
        adjust_balance_and_update_status_for_invoice
        flash.notice = "Payment is being processed."
      else
        flash[:danger] = @transfer.error
      end
    end

    def set_invoice
      @invoice = Invoice.find(params[:invoice])
    end

    def set_payee
      @payee = @invoice.submitter
    end

    def set_funding_source
      @funding_source = FundingSource.last
    end

    def validate_funding_source
      return unless @funding_source.nil?
      flash[:danger] = "Funding source is not set. Please contact the administrator."
      redirect_back(fallback_location: dashboard_path)
    end

    def adjust_balance_and_update_status_for_invoice
      CreditUpdater.new(@invoice).process_payment_of_invoice!
    end
  end
end
