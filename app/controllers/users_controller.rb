class UsersController < Clearance::SessionsController
  before_action :require_login

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def update
    student_name = user_params[:student][:name]
    student_email = user_params[:student][:email]
    current_user.update(
      name: user_params[:name],
      email: user_params[:email],
      phone_number: user_params[:phone_number])

    if student_email != user_params[:email]
      student = User.create(
        email: student_email,
        name: student_name,
        password: SecureRandom.hex(10)
      )
      current_user.students << student
      if current_user.save
        student.enable!
        student.forgot_password!
        SetStudentPasswordMailer.set_password(student).deliver_now
      end
    else
      #Do not create student but save engagement info
    end

    current_user.enable!

    student_id = student.id if student
    engagement = Engagement.create(
      student_id: student_id,
      student_name: student_name,
      # The below will be replaced by subject_id when client_info goes away
      subject: current_user.client_info.subject,
      client_id: current_user.id,
      academic_type: params.require(:student_academic_type)
    )

    if engagement
      redirect_to dashboard_path
    else
      redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: current_user.errors.full_messages })
    end
  end

  private

  def user_params
    if current_user.is_student?
      client_as_student_params
    else
      client_params
    end
  end

  def client_as_student_info_params
    params.require(:info).permit(:academic_type, :subject)
  end

  def client_params
    params.require(:user).permit(:name, :email, :phone_number, :password, student: [:id, :name, :email, :phone_number, :password, :subject])
  end


  def student_academic_type
    params[:student_academic_type]
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number, :password, client_info_attributes: [:id])
  end
end
