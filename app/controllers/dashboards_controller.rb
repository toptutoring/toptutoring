class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]

  def admin
    @assignments = Assignment.pending
  end

  def director
    @assignments = Assignment.pending
  end

  def tutor
    @assignments = current_user.assignments 
    @students = User.where(id: @assignments.pluck(:student_id))
    @invoice = Invoice.new(student_id: @students.first.try(:id))
  end

  private

  def build_student_for_client
    if !current_user.is_student?
      current_user.students.build
    end
  end
end
