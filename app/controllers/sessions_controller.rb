class SessionsController < Clearance::SessionsController
  layout "authentication"

  def new
  end

  # Change clearance's flash message from notice to error.
  def create
    set_remember_me
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash.now[:error] = "Invalid email or password."
        render template: "sessions/new", status: :unauthorized
      end
    end
  end

  private

  def url_after_create
    if current_user.has_role?("client") &&
        current_user.enabled? &&
          !(current_user&.students&.first&.student_engagements&.first&.pending? || current_user&.client_engagements&.first&.pending?)
      new_payment_path
    else
      dashboard_path
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
