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
    base_url = "https://connect.stripe.com/express/oauth/authorize?&client_id="
    csrf_hash = "&state=#{SecureRandom.hex(8)}"
    business_type = "&stripe_user[business_type]=individual"
    first_name = "&stripe_user[first_name]=#{current_user.first_name}"
    last_name = "&stripe_user[last_name]=#{current_user.last_name}"
    email = "&stripe_user[email]=#{current_user.email}"
    @stripe_url = URI.encode(base_url + ENV.fetch("STRIPE_CONNECT_CLIENT_ID") + csrf_hash + business_type + first_name + last_name + email)
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
