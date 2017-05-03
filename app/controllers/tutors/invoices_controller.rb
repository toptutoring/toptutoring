module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login
    before_action :set_student, :set_engagement, :authorize_tutor, only: :create

    def index
      @invoices = current_user.invoices
    end

    def create
      @invoice = Invoice.new(invoice_params)
      if @invoice.save
        @invoice.cancelled! if @invoice.hours == 0
        credit = CreditUpdater.new(@invoice.id).process!
        if credit <= 0.5 && @invoice.hours != 0
          redirect_to tutors_students_path, alert: 'The session has been logged but the client
                        has a negative balance of hours. You may not be paid for this session
                        unless the client adds to his/her hourly balance.' and return
        else
          redirect_to tutors_students_path, notice: 'Session successfully logged!' and return
        end
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages }) and return
      end
    end

    private
    def invoice_params
      if params[:academic_type].casecmp('academic') == 0
        hourly_rate = MultiCurrencyAmount.from_cent(@student.client.academic_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
      else
        hourly_rate = MultiCurrencyAmount.from_cent(@student.client.test_prep_rate.cents, MultiCurrencyAmount::APP_DEFAULT_CURRENCY)
      end
      params.require(:invoice)
        .permit(:student_id, :hours, :subject, :description)
        .merge(tutor_id: current_user.id, hourly_rate: hourly_rate, engagement_id: @engagement.id)
    end

    def set_student
      @student = User.find(params[:invoice][:student_id])
    end

    def set_engagement
      @engagement = Engagement.find_by(tutor_id: current_user.id, student_id: @student.id, academic_type: params[:academic_type])
    end

    def authorize_tutor
      if @student.student_engagements.blank? || @student.student_engagements.pluck(:tutor_id).exclude?(current_user.id)
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      end
    end
  end
end
