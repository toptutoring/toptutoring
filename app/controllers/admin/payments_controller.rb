module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_auth_tutor, only: :new
    before_action :set_funding_source, :validate_funding_source, :validate_payment, only: :create

    def index
      @parent_payments = Payment.from_parents
      if current_user.admin
        @tutor_payments = Payment.to_tutor
      elsif current_user.is_director?
        @tutor_payments = Payment.from_user(current_user.id)
      end
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
      params.require(:payment).permit(:amount, :source, :description, :destination,
      :payee_id, :payer_id).merge(source: @funding_source.id)
    end

    def set_funding_source
      @funding_source = DwollaService.new.funding_source
    end

    def validate_funding_source
      if @funding_source.empty?
        flash[:danger] = "Something went wrong! Please contact your administrator."
        redirect_to new_admin_payment_path
      end
    end

    def set_auth_tutor
      @tutors = User.tutors_with_external_auth
    end

    def validate_payment
      if current_user.is_director?
        if User.find(payment_params[:payee_id]).balance.to_f * 0.9 < payment_params[:amount].to_f
          flash[:danger] = 'This exceeds the maximum payment for this tutor.
            Please contact an administrator if you have any questions'
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
