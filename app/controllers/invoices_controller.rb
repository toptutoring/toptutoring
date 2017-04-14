class InvoicesController < ApplicationController
  before_action :require_login
  before_action :set_student, :authorize_tutor, only: [:new, :create]

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      UpdateUserBalance.new(@invoice.amount, current_user.id).increase
      if @student.is_student?
        UpdateUserBalance.new(@invoice.amount, @student.id).decrease
        @student.reload
      else
        UpdateUserBalance.new(@invoice.amount, @student.client.id).decrease
        @student.client.reload
      end

      balance = @student.is_student? ? @student.balance.to_f : @student.client.balance.to_f

      if balance < 0
        redirect_to tutors_students_path, alert: 'The session has been logged but the client 
                      has a negative balance of hours. You may not be paid for this session 
                      unless the client adds to his/her hourly balance.'
      else 
        redirect_to tutors_students_path, notice: 'Session successfully logged!'
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
    @student = User.find(params[:id])
  end

  def authorize_tutor
    if @student.assignment.nil? || @student.assignment.tutor_id != current_user.id
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end
end
