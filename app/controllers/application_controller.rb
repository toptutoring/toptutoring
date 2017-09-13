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

  def must_be_admin_or_director
    unless current_user.has_role?("admin") or current_user.has_role?("director")
      flash[:error] = "Must be admin or director to masquerade"
      redirect_to root_url
    end
  end

  def masquerading?
    session[:admin_id].present?
  end
  helper_method :masquerading?
end
