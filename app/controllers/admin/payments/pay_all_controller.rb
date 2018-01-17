module Admin
  module Payments
    class PayAllController < ApplicationController
      before_action :require_login
      before_action :validate_funding_source, only: :create

      def create
        result = MassPaymentService.new(user_invoices, current_user, type)
                                   .pay_all
        if result.success?
          flash.notice = result.message
        else
          flash.alert = result.message
        end
        redirect_to return_path
      end

      private

      def user_invoices
        # This user object has additional invoice attributes
        User.with_pending_invoices_attributes(type)
      end

      def type
        params.require(:pay_type)
      end

      def validate_funding_source
        return unless FundingSource.first.nil?
        flash.alert = "Please select a funding source before making a payment."
        redirect_to return_path
      end

      def return_path
        type == "by_tutor" ? admin_invoices_path : admin_timesheets_path
      end
    end
  end
end
