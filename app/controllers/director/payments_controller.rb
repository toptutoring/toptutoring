module Director
  class PaymentsController < ApplicationController
    before_action :require_login

    def index
      @payments = Payment.order(created_at: :desc)
      @payouts = Payout.tutors.order(created_at: :desc).where(approver: current_user)
      render "admin/payments/index"
    end
  end
end
