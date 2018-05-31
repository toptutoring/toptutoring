module Admin
  module Payments
    class RefundsController < ApplicationController
      before_action :require_login, :set_payment

      def create
        refund = build_refund
        if StripeRefundService.new(@payment, refund).process_refund!
          flash.notice = "Refunded payment to #{@payment.payer.full_name}."
        else
          flash.alert = "Failed to refund #{@payment.payer.full_name}."
        end
        redirect_to admin_payments_path
      end

      private

      def build_refund
        @payment.refunds.build(refund_params).tap(&:set_amount)
      end

      def refund_params
        params.require(:refund)
              .permit(:hours, :reason)
      end

      def set_payment
        @payment = Payment.find(params[:payment_id])
      end
    end
  end
end
