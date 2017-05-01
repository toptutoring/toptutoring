class UsersController < Clearance::SessionsController
  before_action :require_login

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def update
    if current_user.update_attributes(user_params)
      if !current_user.is_student?
        current_user.students.last.create_student_info(subject: current_user.client_info.subject, academic_type: student_academic_type)
      end
    else redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: current_user.errors.full_messages })
      return
    end

    enable_user
    redirect_to dashboard_path
    return
  end

  private

  def enable_user
    if current_user.is_student?
      EnableUserAsStudent.new(current_user, params).perform
    else
      EnableUserWithStudent.new(current_user).perform
      if current_user.students.last.email.present?
        current_user.students.last.forgot_password!
        SetStudentPasswordMailer.set_password(current_user.students.last).deliver_now
      end
    end
  end

  def user_params
    if current_user.is_student?
      client_as_student_params
    else
      client_with_student_params
    end
  end

  def client_with_student_params
    params[:user][:students_attributes]["0"][:password] = rand(36**4).to_s(36)
    params.require(:user).permit(:name, :email, :phone_number, :password, students_attributes: [:id, :name, :email, :phone_number, :password, :subject])
  end

  def student_academic_type
    params[:student_academic_type]
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number, :password, client_info_attributes: [:id])
  end
end
