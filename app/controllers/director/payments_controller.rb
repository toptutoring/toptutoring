module Director
  class PaymentsController < ApplicationController
    before_action :require_login

    def index
      @client_payments = Payment.all
      @tutor_payments = current_user.approved_payouts
    end
  end
end
