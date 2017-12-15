class UsersController < Clearance::SessionsController
  before_action :require_login

  def edit
    @user = current_user
  end

  def update
    onboard_service = OnboardClientService.new(current_user, user_params)
    results = onboard_service.onboard_client!
    if results.success?
      AdminDirectorNotifierMailer.new_user_finished_sign_up(current_user).deliver_later
      flash.notice = results.message
    else
      flash.alert = results.message
    end
    redirect_to dashboard_path
  end

  private

  def user_params
    current_user.signup.student ? client_as_student_params : client_params
  end

  def client_as_student_params
    params.require(:user).permit(:phone_number)
  end

  def client_params
    params.require(:user).permit(:phone_number, student: [:name, :email])
  end
end
