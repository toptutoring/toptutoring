class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]

  def admin
    @pending_engagements = Engagement.pending
  end

  def director
    @pending_engagements = Engagement.pending
    @tutor_engagements = current_user.tutor_engagements
    @invoice = Invoice.new()
  end

  def tutor
    @tutor_engagements = current_user.tutor_engagements
    @invoice = Invoice.new()
  end

  def client
    @availability_engagement = current_user&.student_engagements&.first || current_user&.client_engagements&.first
  end

  private

  def build_student_for_client
    if !current_user.is_student?
      current_user.students.build
    end
  end
end
