class SessionsController < Clearance::SessionsController
  def new
  end

  def create
    set_remember_me
    super
  end

  private

  def url_after_create
    payment_path
  end

  def set_remember_me
    if params[:session][:remember_me]
      cookies.permanent[:remember_me] = true
    else
      cookies.delete(:remember_me)
    end
  end
end
