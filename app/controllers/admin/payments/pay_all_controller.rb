module Admin
  module Payments
    class PayAllController < ApplicationController
      before_action :require_login
      before_action :check_dwolla, :validate_funding_source, only: :create

      def create
        pay_all_pending
        @payment_service.update_processing_to_paid if payment_successful?
        set_flash_messages
        redirect_back(fallback_location: (request.referer || root_path)) and return
      end

      private

      def pay_all_pending
        type = params[:pay_type]
        @payment_service = MassPaymentService.new(type, current_user)
        @payment_service.pay_all
      end

      def set_flash_messages
        flash.notice = @payment_service.messages
        flash[:danger] = @payment_service.errors unless payment_successful?
      end

      def payment_successful?
        @payment_service.errors.empty?
      end

      def check_dwolla
        return if current_user.has_valid_dwolla?
        flash[:danger] = "You must authenticate with Dwolla before making a payment."
        redirect_back(fallback_location: (request.referer || root_path)) and return
      end

      def validate_funding_source
        return unless FundingSource.last.nil?
        flash[:danger] = "You must select a funding source before making a payment."
        redirect_back(fallback_location: (request.referer || root_path)) and return
      end
    end
  end
end
