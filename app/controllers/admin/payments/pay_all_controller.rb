module Admin
  module Payments
    class PayAllController < ApplicationController
      before_action :require_login
      before_action :validate_funding_source, only: :create

      def create
        pay_all_pending
        status = payment_successful? ? "paid" : "pending"
        @payment_service.update_processing(status)
        set_flash_messages
        redirect_to return_path
      end

      private

      def pay_all_pending
        @payment_service = MassPaymentService.new(type, current_user)
        @payment_service.pay_all
      end

      def type
        params.require(:pay_type)
      end

      def set_flash_messages
        flash.notice = @payment_service.messages
        flash[:danger] = @payment_service.errors unless payment_successful?
      end

      def payment_successful?
        @payment_service.errors.empty?
      end

      def validate_funding_source
        return unless FundingSource.first.nil?
        flash[:danger] = "You must select a funding source before making a payment."
        redirect_to return_path
      end

      def return_path
        type == "by_tutor" ? admin_invoices_path : admin_timesheets_path
      end
    end
  end
end
