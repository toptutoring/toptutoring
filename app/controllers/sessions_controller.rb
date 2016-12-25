class SessionsController < Clearance::SessionsController
  layout "authentication"

  def new
  end

  def create
    set_remember_me
    super
  end

  private

  def url_after_create
    if current_user.parent?
      payment_path
    elsif current_user.tutor?
      example_dashboard_path
    end
end

  def set_remember_me
    if params[:session][:remember_me]
      cookies.permanent[:remember_me] = true
    else
      cookies.delete(:remember_me)
    end
  end
end
