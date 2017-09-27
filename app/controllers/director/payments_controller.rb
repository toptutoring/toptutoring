module Director
  class PaymentsController < ApplicationController
    before_action :require_login

    def index
      @client_payments = Payment.from_clients
      @tutor_payments = Payment.from_user(current_user.id)
    end
  end
end
