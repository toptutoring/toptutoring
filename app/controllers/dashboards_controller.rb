class DashboardsController < ApplicationController
  before_action :require_login

  def admin
    @assignments = Assignment.pending
  end

  def director
    @assignments = Assignment.pending
  end

  def tutor
    @assignments = Assignment.where(tutor_id: current_user.id)
  end
end
