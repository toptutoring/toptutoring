class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]

  def admin
    @pending_engagements = Engagement.pending.includes(:client, :tutor)
  end

  def director
    @pending_engagements = Engagement.pending.includes(:client, :tutor)
    @tutor_engagements = current_user.tutor_engagements.includes(:suggestions)
    @low_balance_engagements = low_balance_engagements?
    @invoice = Invoice.new()
    @suggestion = Suggestion.new()
  end

  def tutor
    @tutor_engagements = current_user.tutor_engagements.includes(:client, :suggestions)
    @low_balance_engagements = low_balance_engagements?
    @invoice = Invoice.new()
    @suggestion = Suggestion.new()
  end

  def client
    @engagements = current_user.engagements.includes(:tutor, :availabilities)
    @engagements = @engagements.sort_by { |engagement| engagement.try(:tutor).try(:name) }
    @academic_types = current_user.academic_types_engaged
  end

  def student
    @engagements = current_user.engagements.includes(:tutor, :availabilities)
    @engagements = @engagements.sort_by { |engagement| engagement.try(:tutor).try(:name) }
    @academic_types = current_user.academic_types_engaged
  end

  private

  def build_student_for_client
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def low_balance_engagements?
    results = []
    @tutor_engagements.each do |engagement|
      next if engagement.suggestions.any? { |suggestion| suggestion.status == "pending" }
      client =User.find(engagement.client_id)
      if engagement.academic_type == "Test_Prep"
        results << option_array(engagement, client.test_prep_credit) if client.test_prep_credit < 2
      else
        results << option_array(engagement, client.academic_credit) if client.academic_credit < 2
      end
    end
    results.empty? ? false : results
  end

  def option_array(engagement, credit)
    ["#{engagement.student_name} for #{engagement.subject} - #{credit} Credits", engagement.id]
  end
end
