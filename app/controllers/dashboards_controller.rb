class DashboardsController < ApplicationController
  before_action :require_login

  def admin
    @assignments = Assignment.pending
  end
end
