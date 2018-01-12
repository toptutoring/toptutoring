class AuthCallbacksController < ApplicationController
  def create
    user_from_auth_hash
    redirect_to dashboard_path
  end

  private

  def user_from_auth_hash
    if current_user
      AuthHashService.new(auth_hash).set_token(current_user)
    else
      sign_in AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash
    end
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
