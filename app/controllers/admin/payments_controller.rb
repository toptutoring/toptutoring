module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_funding_sources, :set_auth_tutor, only: :new
    before_action :validate_payment, only: :create

    def index
      @payments = Payment.from_parents
    end

    def new
      @payment = Payment.new
    end

    def create
      @payment = Payment.new(payment_params)
      @payment.destination = User.find(@payment.payee_id).auth_uid
      if @payment.save
        TransferWorker.perform_async(@payment.id)
        redirect_to admin_payments_path, notice: 'Payment successfully made.'
      else
        flash[:danger] = "You must provide your card information before making a payment."
        redirect_to :back
      end
    end

    private

    def payment_params
      params.require(:payment).permit(:amount, :source, :description, :destination, :payee_id, :payer_id)
    end

    def set_funding_sources
      @funding_sources = DwollaService.new(current_user).funding_sources
    end

    def set_auth_tutor
      @tutors = User.all.select { |user| user.tutor? && user.has_external_auth? }
    end

    def validate_payment
      if current_user.director?
        if User.find(payment_params[:payee_id]).balance.to_f * 0.9 < payment_params[:amount].to_f
          flash[:danger] = 'Tutor cannot be paid more than 90% of his earnings.'
          redirect_to :back
        end
      end
    end
  end
end
