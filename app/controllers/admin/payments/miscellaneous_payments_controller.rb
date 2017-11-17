module Admin
  module Payments
    class MiscellaneousPaymentsController < ApplicationController
      def new
        @payment = Payment.new
        @tutors = User.tutors_with_external_auth
      end

      def create
        if set_funding_source
          create_payment
        else
          flash[:error] = "Funding source is not set. Please contact the administrator."
        end
        redirect_back fallback_location: dashboard_path
      end

      private

      def set_funding_source
        @funding_source = FundingSource.first
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
        params.require(:payment)
              .permit(:amount, :description, :payee_id)
              .merge(source: @funding_source.funding_source_id,
                     payer: @funding_source.user,
                     approver: current_user)
      end

      def process_payment
        @transfer = PaymentGatewayDwolla.new(@payment)
        @transfer.create_transfer
        if @transfer.error.nil?
          @payment.save!
          flash.notice = "Payment is being processed."
        else
          flash[:danger] = @transfer.error
        end
      end
    end
  end
end
