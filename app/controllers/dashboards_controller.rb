class DashboardsController < ApplicationController
  before_action :require_login

  def admin
    @assignments = Assignment.pending.order('created_at DESC')
  end
end
