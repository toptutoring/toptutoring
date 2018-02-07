module Admin
  module Payments
    class MiscellaneousPaymentsController < ApplicationController
      def new
        @payout = Payout.new
        @tutors = User.includes(:tutor_account).tutors_with_external_auth
      end

      def create
        if set_funding_source
          create_payout
        else
          flash.alert = "Funding source is not set. Please contact the administrator."
        end
        redirect_to new_admin_payments_miscellaneous_payment_path
      end

      private

      def set_funding_source
        @funding_source = FundingSource.first
      end

      def create_payout
        @payout = Payout.new(payout_params)
        if @payout.valid?
          process_payout
        else
          flash.alert = @payout.errors.full_messages
        end
      end

      def payout_params
        params.require(:payout)
              .permit(:amount, :description, :receiving_account_id)
              .merge(funding_source: @funding_source.funding_source_id,
                     destination: auth_uid,
                     receiving_account_type: "TutorAccount",
                     approver: current_user)
      end

      def auth_uid
        TutorAccount.find(params[:payout][:receiving_account_id]).user.auth_uid
      end

      def process_payout
        result = DwollaPaymentService.charge!(@payout)
        if result.success?
          flash.notice = result.message
        else
          flash.alert = result.message
        end
      end
    end
  end
end
