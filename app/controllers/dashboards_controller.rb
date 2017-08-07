class DashboardsController < ApplicationController
  before_action :require_login
  before_action :build_student_for_client, only: [:client]

  def show
    if current_user.has_role?("admin")
      @pending_engagements = Engagement.pending
      render :admin
    elsif current_user.has_role?("director")
      @pending_engagements = Engagement.pending
      @tutor_engagements = current_user.tutor_engagements
      @invoice = Invoice.new()
      render :director
    elsif current_user.has_role?("tutor")
      @tutor_engagements = current_user.tutor_engagements
      @low_balance_engagements = low_balance_engagements?
      @invoice = Invoice.new()
      @timesheet = Timesheet.new()
      @suggestion = Suggestion.new()
      render :tutor
    elsif current_user.has_role?("client")
      @availability_engagement = current_user&.student_engagements&.first ||
	      current_user&.client_engagements&.first
      render :client
    end
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
