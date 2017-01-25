class InvoicesController < ApplicationController
  before_action :require_login
  before_action :set_student, :authorize_tutor, only: [:new, :create]

  def new
    @invoice = Invoice.new
  end

  def create
    if @invoice = Invoice.create(invoice_params)
      UpdateUserBalance.new(@invoice.amount, current_user.id).increase
      UpdateUserBalance.new(@invoice.amount, @student.id).decrease
      redirect_to tutors_students_path, notice: 'Session successfully logged!'
    else
      redirect_to :back, flash: { error: @invoice.errors.full_messages }
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