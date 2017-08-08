module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_auth_tutor, only: :new
    before_action :set_funding_source, :validate_funding_source, :set_payee, :check_dwolla, :set_invoice_or_timesheet, only: :create

    def index
      @client_payments = Payment.from_clients
      @tutor_payments = Payment.to_tutor
    end

    def new
      @payment = Payment.new
      @tutors = User.tutors
    end

    def create
      @payment = Payment.new(payment_params)
      if @payment.valid?
        process_payment
      else
        flash[:danger] = @payment.errors.full_messages
      end
      redirect_back(fallback_location: (request.referer || root_path)) and return
    end

    private

    def payment_params
      amount = params[:amount].to_f * 100
      params.require(:payment)
            .permit(:source, :description, :payee_id, :payer_id)
        .merge(amount_in_cents: amount.to_i, source: @funding_source.funding_source_id)
    end

    def set_funding_source
      @funding_source = FundingSource.last
    end

    def validate_funding_source
      return unless @funding_source.nil?
      flash[:danger] = "You must authenticate with Dwolla and select a funding source before making a payment."
      redirect_back(fallback_location: (request.referer || root_path)) and return
    end

    def set_auth_tutor
      @tutors = User.tutors_with_external_auth
    end

    def process_payment
      @transfer = Transfer.new(@payment)
      if @transfer.perform
        @payment.save!
        @object_to_update_status.update(status: "paid") if @object_to_update_status
        flash.notice = "Payment is being processed."
      else
        flash[:danger] = transfer_error
      end
    end

    def transfer_error
      @transfer.instance_variable_get(:@gateway).error
    end

    def set_payee
      @payee = User.find(payment_params[:payee_id])
    end

    def check_dwolla
      return if @payee.has_valid_dwolla?
      flash[:danger] = "#{@payee.name} does not have Dwolla authenticated. Payment was cancelled."
      redirect_back(fallback_location: (request.referer || root_path)) and return
    end
    
    def set_invoice_or_timesheet
      if params[:invoice]
        @object_to_update_status = Invoice.find(params[:invoice].to_i)
      elsif params[:timesheet]
        @object_to_update_status = Timesheet.find(params[:timesheet].to_i)
      end
    end
  end
end
