module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_auth_tutor, only: :new
    before_action :set_funding_source, :validate_funding_source, :set_payee, :set_invoice_or_timesheet, only: :create

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
      redirect_to admin_invoices_path
    end

    private

    def payment_within_balance?
      return true unless @object_to_update_status
      @payee = User.find(params[:payment][:payee_id])
      @payee.outstanding_balance >= @object_to_update_status.hours
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
        BalanceAdjuster.lower_balance_and_update(@payee, @object_to_update_status) if @object_to_update_status
        flash.notice = "Payment is being processed."
      else
        flash[:danger] = @transfer.error
      end
    end

    def set_payee
      @payee = User.find(payment_params[:payee_id])
    end

    def set_invoice_or_timesheet
      if params[:invoice]
        @object_to_update_status = Invoice.find(params[:invoice].to_i)
      elsif params[:timesheet]
        @object_to_update_status = Timesheet.find(params[:timesheet].to_i)
      end
    end

    def set_funding_source
      @funding_source = FundingSource.last
    end

    def validate_funding_source
      return unless @funding_source.nil?
      flash[:danger] = "Funding source is not set. Please contact the administrator."
      redirect_back(fallback_location: (request.referer || root_path)) and return
    end

    def set_auth_tutor
      @tutors = User.tutors_with_external_auth
    end
  end
end
