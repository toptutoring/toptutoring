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
    @tutor_engagements = current_user.tutor_account.engagements.includes(:suggestions)
    @low_balance_engagements = low_balance_engagements?
    @invoice = Invoice.new()
    @suggestion = Suggestion.new()
  end

  def tutor
    @tutor_engagements = current_user.tutor_account.engagements.includes(:client_account, :suggestions)
    @low_balance_engagements = low_balance_engagements?
    @invoice = Invoice.new()
    @suggestion = Suggestion.new()
  end

  def client
    @engagements = current_user.client_account
                               .engagements
                               .includes(:subject, :student_account, :availabilities, tutor_account: :user)
                               .order("users.name")
    @academic_types = current_user.client_account.academic_types_engaged
  end

  def student
    @engagements = current_user.student_account
                               .engagements
                               .includes(:subject, :student_account, :availabilities, tutor_account: :user)
                               .order("users.name")
    @academic_types = current_user.student_account.academic_types_engaged
  end

  private

  def low_balance_engagements?
    results = []
    @tutor_engagements.each do |engagement|
      next if engagement.suggestions.any? { |suggestion| suggestion.status == "pending" }
      client = engagement.client
      if engagement.academic_type == "test_prep"
        results << option_array(engagement, client.test_prep_credit) if client.test_prep_credit < 2
      else
        results << option_array(engagement, client.academic_credit) if client.academic_credit < 2
      end
    end
    results.empty? ? false : results
  end

  def option_array(engagement, credit)
    ["#{engagement.student_name} for #{engagement.subject.name} - #{credit} Credits", engagement.id]
  end
end
