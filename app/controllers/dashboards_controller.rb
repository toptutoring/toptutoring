class DashboardsController < ApplicationController
  before_action :require_login

  def admin
    @pending_engagements = Engagement
                           .pending
                           .includes(:student_account,
                                     :subject, tutor_account: :user, client_account: :user)
  end

  def director
    @pending_engagements = Engagement.pending.includes(:student_account, :subject, tutor_account: :user, client_account: :user)
    @tutor_engagements = current_user.tutor_account.engagements
    @invoice = Invoice.new()
  end

  def tutor
    @tutor_engagements = current_user.tutor_account.engagements.includes(:client_account)
    @pending_invoices = current_user.invoices.by_tutor.pending
    @invoice = Invoice.new
  end

  def client
    @engagements = current_user.client_account
                               .engagements
                               .includes(:subject, :student_account, :availabilities, tutor_account: :user)
                               .order("users.first_name")
    @academic_types = current_user.client_account.academic_types_engaged
  end

  def student
    @engagements = current_user.student_account
                               .engagements
                               .includes(:subject, :student_account, :availabilities, tutor_account: :user)
                               .order("users.first_name")
    @academic_types = current_user.student_account.academic_types_engaged
  end

  def contractor
    @invoice = Invoice.new
  end
end
