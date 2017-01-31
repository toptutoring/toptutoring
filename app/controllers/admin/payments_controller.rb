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
      params.require(:payment).permit(:amount, :source, :description, :destination, :payee_id, :payer_id)
    end

    def set_funding_sources
      @funding_sources = DwollaService.new(current_user).funding_sources
    end

    def set_auth_tutor
      if current_user.admin?
        @tutors = User.tutors_with_external_auth
      else
        @tutors = User.tutors_for_director_with_external_auth
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

    def perform_transfer
      @transfer = Transfer.new(@payment)
      @transfer.perform
      @transfer.error ? false : true
    end

    def transfer_error
      @transfer.error
    end
  end
end
