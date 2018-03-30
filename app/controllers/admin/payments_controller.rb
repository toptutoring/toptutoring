module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_funding_source, :validate_funding_source, :set_invoice, :set_payee, only: :create
    
    def index
      @payments = Payment.order(created_at: :desc).includes(:payer)
      @payouts = Payout.tutors.order(created_at: :desc)
    end

    def create
      @payout = @invoice.build_payout(payout_params)
      if @payout.valid?
        process_payout
      else
        flash.alert = @payout.errors.full_messages
      end
      redirect_back fallback_location: dashboard_path
    end

    private

    def payout_params
      {
        description: @invoice.description,
        destination: @payee.auth_uid,
        receiving_account: account,
        funding_source: @funding_source.funding_source_id,
        approver: current_user,
        amount: @invoice.submitter_pay
      }
    end

    def account
      if @invoice.by_tutor?
        @payee.tutor_account
      else
        @payee.contractor_account
      end
    end

    def process_payout
      result = DwollaPaymentService.charge!(@payout)
      if result.success?
        adjust_balance_and_update_status_for_invoice
        flash.notice = result.message
      else
        flash.alert = result.message
      end
    end

    def set_invoice
      @invoice = Invoice.find(params[:invoice])
    end

    def set_payee
      @payee = @invoice.submitter
    end

    def set_funding_source
      @funding_source = FundingSource.first
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
