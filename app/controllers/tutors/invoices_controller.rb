module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login
    before_action :set_client, :set_engagement, :authorize_tutor, only: :create

    def index
      @invoices = current_user.invoices
    end

    def create
      @invoice = Invoice.new(invoice_params)
      
      if params[:suggestion][:number_of_hours] != ''
        @suggestion = Suggestion.new(suggestion_params)
        unless @suggestion.save
          redirect_back(fallback_location: (request.referer || root_path),
                        flash: { error: [@suggestion.errors.full_messages, ". Invoice was not created."].join(' ') }) and return
        end
      end

      if @invoice.save
        @invoice.cancelled! if @invoice.hours == 0
        credit = CreditUpdater.new(@invoice.id).process!
        if credit <= 0.5 && @invoice.hours != 0
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
      if @engagement.academic_type == 'Academic'
        hourly_rate = MultiCurrencyAmount.from_cent(@client.academic_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
      else
        hourly_rate = MultiCurrencyAmount.from_cent(@client.test_prep_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
      end
      params.require(:invoice)
        .permit(:client_id, :hours, :engagement_id, :subject, :description)
        .merge(tutor_id: current_user.id, hourly_rate: hourly_rate)
    end

    def suggestion_params
      params.require(:suggestion)
        .permit(:number_of_hours)
        .merge(engagement_id: @engagement.id)
    end

    def set_client
      @client = User.find(params[:invoice][:client_id])
    end

    def set_engagement
      @engagement = Engagement.find_by(id: params[:invoice][:engagement_id])
    end

    def authorize_tutor
      if @client.client_engagements.blank? || @client.client_engagements.pluck(:tutor_id).exclude?(current_user.id)
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      end
    end
  end
end
