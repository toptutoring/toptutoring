module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_auth_tutor, only: :new
    before_action :set_funding_source, :validate_funding_source, :set_payee, only: :create

    def index
      @client_payments = Payment.from_clients
      @tutor_payments = Payment.to_tutor
    end

    def new
      @payment = Payment.new
      @tutors = User.with_tutor_role
    end

    def create
      @payment = Payment.new(payment_params)
      if @payment.valid?
        if perform_transfer
          @payment.save!
          redirect_to admin_payments_path, notice: 'Payment is being processed.'
        else
          flash[:danger] = transfer_error
          redirect_to new_admin_payment_path
        end
      else
        flash[:danger] = @payment.errors.full_messages
        redirect_to new_admin_payment_path
      end
    end

    private

    def payment_params
      params.require(:payment)
        .permit(:amount, :source, :description, :destination, :payee_id, :payer_id)
        .merge(source: @funding_source.funding_source_id)
    end

    def set_funding_source
      @funding_source = FundingSource.last
    end

    def validate_funding_source
      if @funding_source.nil?
        flash[:danger] = "You must authenticate with Dwolla and select a funding source before making a payment."
        redirect_to new_admin_payment_path
      end
    end

    def set_auth_tutor
      @tutors = User.tutors_with_external_auth
    end

    def perform_transfer
      @transfer = Transfer.new(@payment)
      @transfer.perform
    end

    def transfer_error
      @transfer.error
    end

    def set_payee
      @payee = User.find(payment_params[:payee_id])
    end
  end
end
