module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login
    before_action :authorize_tutor, :set_engagement, :set_client, only: :create

    def index
      @invoices = current_user.invoices.newest_first
    end

    def create
      @invoice = Invoice.new(invoice_params)
      if @invoice.save
        credit_updater = CreditUpdater.new(@invoice.id)
        credit_updater.process!
        if credit_updater.client_balance < 0 && @invoice.hours != 0
          redirect_to tutors_students_path, alert: 'The session has been logged but the client
                        has a negative balance of hours. You may not be paid for this session
                        unless the client adds to his/her hourly balance.' and return
        else
          redirect_to tutors_invoices_path, notice: 'Session successfully logged!' and return
        end
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    private
    def invoice_params
      if @engagement.academic_type.casecmp('academic') == 0
        hourly_rate = MultiCurrencyAmount.from_cent(@client.academic_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
      else
        hourly_rate = MultiCurrencyAmount.from_cent(@client.test_prep_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
      end
      params.require(:invoice)
        .permit(:engagement_id, :hours, :subject, :description)
        .merge(tutor_id: current_user.id, hourly_rate: hourly_rate, status: "pending")
    end

    def set_client
      @client = User.find(@engagement.client_id)
    end

    def set_engagement
      @engagement = current_user.tutor_engagements.find(params[:invoice][:engagement_id])
    end

    def authorize_tutor
      unless current_user.tutor_engagements.where(state: "active").pluck(:id).include?(params[:invoice][:engagement_id].to_i)
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: "There was an error while processing your invoice." }) and return
      end
    end
  end
end
