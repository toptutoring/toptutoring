class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]
  include ApplicationHelper

  def admin
    @assignments = Assignment.pending
  end

  def director
    @assignments = Assignment.pending
  end

  def tutor
    @assignments  = current_user.assignments
    @student      = current_user.students.first
    @student_list = generate_student_dropdown_list
    @invoice      = Invoice.new
  end

  private

  def build_student_for_client
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def generate_student_dropdown_list
    student_ids  = current_user.assignments.pluck(:student_id)
    student_list = [["Select student", "0"]]
    student_ids.each do |id|
      student = User.find(id)
      student_list << ["#{student.name}", "#{id}"]
    end
    student_list
  end
end
