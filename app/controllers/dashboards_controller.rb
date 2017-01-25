class DashboardsController < ApplicationController
  before_action :require_login

  def admin
    @assignments = Assignment.pending
  end

  def director
    @assignments = Assignment.pending
  end

  def tutor
    @assignments = current_user.assignments
  end
end
