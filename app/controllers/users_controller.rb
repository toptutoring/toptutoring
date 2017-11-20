class UsersController < Clearance::SessionsController
  before_action :require_login
  after_action :ping_slack, only: [:update]

  def edit
    @user = current_user
  end

  def update
    strong_params = student? ? client_as_student_params : client_params
    onboard_service = OnboardClientService.new(current_user, strong_params)
    results = onboard_service.onboard_client!
    if results.success?
      NewClientNotifierMailer.finished_sign_up(current_user).deliver_later
      flash.notice = results.message
    else
      flash.alert = results.message
    end
    redirect_to dashboard_path
  end

  private

  def student?
    current_user.is_student?
  end

  def client_as_student_params
    params.require(:user).permit(:phone_number)
  end

  def client_params
    params.require(:user).permit(:phone_number, student: [:name, :email])
  end

  def ping_slack
    SlackNotifier.notify_user_signed_up(current_user)
  end
end
