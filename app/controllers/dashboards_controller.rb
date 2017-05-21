class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]

  def admin
    @engagements = Engagement.pending
  end

  def director
    @engagements = Engagement.pending
    @students = User.where(id: current_user.tutor_engagements.pluck(:student_id))
    @invoice = Invoice.new(student_id: @students.first.try(:id))
  end

  def tutor
    @engagements = current_user.tutor_engagements
    @students = User.where(id: @engagements.pluck(:student_id))
    @invoice = Invoice.new(student_id: @students.first.try(:id))
  end

  private

  def build_student_for_client
    if !current_user.is_student?
      current_user.students.build
    end
  end
end
