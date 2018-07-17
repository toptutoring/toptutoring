class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  if Rails.env.production?
    force_ssl(host: ENV["SSL_APPLICATION_HOST"])
  end

  def require_login
    unless current_user
      flash[:error] = "Please log in first"
      redirect_to login_url
    end
  end

  def admin?
    current_user.admin?
  end

  def not_found
    raise ActiveRecord::RecordNotFound.new("Not Found")
  end

  def country_code
    code = request.location.country_code
    code == "RD" ? "US" : code || "US"
  end

  def masquerading?
    session[:admin_id].present?
  end
  helper_method :masquerading?
end
