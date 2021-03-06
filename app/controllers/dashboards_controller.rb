class DashboardsController < ApplicationController
  before_action :require_login

  def admin
    @pending_engagements = Engagement.pending
                                     .includes(:student_account, :subject, :invoices,
                                               :tutor_account, client_account: :user)
  end

  def director
    @pending_engagements = Engagement.pending
                                     .includes(:student_account, :subject, :invoices,
                                               :tutor_account, client_account: :user)
    @tutor_engagements = current_user.tutor_account.engagements
    @invoice = Invoice.new()
  end

  def tutor
    @tutor_engagements = current_user.tutor_account.engagements.active.includes(:client_account, :subject, :student_account)
    @pending_invoices = current_user.invoices.by_tutor.pending.includes(:engagement)
    @invoice = Invoice.new
  end

  def client
    @engagements = current_user.client_account
                               .engagements
                               .includes(:subject, :student_account, :availabilities, tutor_account: :user)
                               .order("users.first_name")
  end

  def student
    @engagements = current_user.student_account
                               .engagements
                               .includes(:subject, :student_account, :availabilities, tutor_account: :user)
                               .order("users.first_name")
  end

  def contractor
    @invoice = Invoice.new
  end
end
