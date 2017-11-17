class UsersController < Clearance::SessionsController
  before_action :require_login
  protect_from_forgery except: [:email_is_unique]

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def update
    onboard_service = OnboardClientService.new(current_user, user_params)
    results = onboard_service.onboard_client!
    if results.success?
      flash.notice = results.message
    else
      flash.alert = results.message
    end
    redirect_to dashboard_path
  end

  private

  def user_params
    if current_user.is_student?
      client_as_student_params
    else
      client_params
    end
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number,
                                 :password, signup_attributes: [:id])
  end

  def client_params
    params.require(:user).permit(:name, :email, :phone_number, :password,
                                 student: [:id, :name, :email, 
                                           :phone_number, :password, :subject])
  end

  def email_is_unique
    @email_unique = student_email_unique?
    render :file => "users/email_is_unique.js.erb"
  end

  def student_email_unique?
    student_email = params[:user_student_email]
    if student_email.downcase == current_user.email
      true
    else
      User.where(email: student_email).first.nil?
    end
  end
end
