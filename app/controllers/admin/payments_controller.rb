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
        perform_tranfer
        if transfer_error
          redirect_to new_admin_payment_path
        else
          redirect_to admin_payments_path, notice: 'Payment is being processed.'
        end
      else
        flash[:danger] = @payment.errors
        redirect_to new_admin_payment_path
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
      if current_user.admin?
        @tutors = User.all.select { |user| user.tutor? && user.has_external_auth? }
      else
        @tutors = User.all.select { |user| user.tutor? && user.has_external_auth? && !user.director? }
      end
    end

    def validate_payment
      if current_user.director?
        if User.find(payment_params[:payee_id]).balance.to_f * 0.9 < payment_params[:amount].to_f
          flash[:danger] = 'Tutor cannot be paid more than 90% of his earnings.'
          redirect_to :back
        end
      end
    end

    def transfer_error
      if @transfer.error
        error = JSON.parse @transfer.error.to_s.gsub('=>', ':')
        flash[:danger] = error["_embedded"]["errors"].first["message"]
      end
    end

    def perform_tranfer
      @transfer = Transfer.new(@payment)
      @transfer.perform
    end
  end
end
