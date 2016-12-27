module Admin
  class PaymentsController < ApplicationController
    before_action :require_login
    before_action :set_funding_sources, only: :new

    def index
      @payments = Payment.from_parents
      render "index", :layout => false
    end

    def new
      @payment = Payment.new
      render "new", :layout => false
    end

    def create
      @payment = Payment.new(payment_params)
      @payment.destination = User.find(@payment.destination).auth_uid
      @payment.source = current_user.auth_uid
      @payment.save
      TransferWorker.perform_async(@payment.id)
      redirect_to admin_payments_path
    end

    private

    def payment_params
      params.require(:payment).permit(:amount, :source, :description, :destination)
    end

    def set_funding_sources
      @funding_sources = DwollaService.new(current_user).funding_sources
    end
  end
end
