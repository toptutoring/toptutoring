module Tutors
  class InvoicesController < ApplicationController
    before_action :require_login
    before_action :set_student, only: :create

    def index
      @invoices = current_user.invoices
    end

    def create
      result = CreateInvoiceService.process(invoice_params, @student.id, current_user.id)
      status, balance = result
      
      if status == "success!"
        if balance < 0
          redirect_to dashboard_path, alert: 'The session has been logged but the client 
                        has a negative balance of hours. You may not be paid for this session 
                        unless the client adds to his/her hourly balance.'
        else 
          redirect_to dashboard_path, notice: 'Session successfully logged!'
        end
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @invoice.errors.full_messages })
      end
    end

    private
    def invoice_params
      params.require(:invoice).permit(:student_id, :hours, :description)
      .merge(tutor_id: current_user.id, hourly_rate: @student.assignment.hourly_rate, assignment_id: @student.assignment.id)
    end

    def set_student
      @student = User.find(params[:invoice][:student_id])
    end
  end
end
