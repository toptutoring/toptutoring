class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]
  before_action :check_dwolla_authentication

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

  private

  def build_student_for_client
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def check_dwolla_authentication
    begin
      current_user.has_external_auth?
    rescue
      redirect_to profile_path(dwolla_error: true)
    end
  end
end
