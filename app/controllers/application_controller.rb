class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  if Rails.env.production?
    force_ssl(host: ENV['SSL_APPLICATION_HOST'])
  end

  def require_login
    unless current_user
      flash[:error] = "Please log in first"
      redirect_to login_url
    end
  end

  def masquerading?
    session[:admin_id].present?
  end
  helper_method :masquerading?
end
