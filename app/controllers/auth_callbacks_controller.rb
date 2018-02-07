class AuthCallbacksController < ApplicationController
  before_action :require_login

  def create
    AuthHashService.new(auth_hash).update_dwolla_attributes(current_user)
    redirect_to dashboard_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
