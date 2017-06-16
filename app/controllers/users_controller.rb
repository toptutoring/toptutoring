class UsersController < Clearance::SessionsController
  before_action :require_login

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def profile_edit
  end

  def profile_update
    User.find(current_user.id).update(update_params)
    redirect_to profile_path, flash: { success: "Your profile has been updated." } and return
  end

  def update
    student_name = user_params[:student][:name]
    student_email = user_params[:student][:email]
    current_user.update(
      name: user_params[:name],
      email: user_params[:email],
      phone_number: user_params[:phone_number])

    if student_email_provided?
      student_name = user_params[:student][:name]
      student_email = user_params[:student][:email]
    end
    current_user.update(phone_number: user_params[:phone_number])

    if student_email != user_params[:email]
      student = User.create(
        email: student_email,
        name: student_name,
        password: SecureRandom.hex(10)
      )
      current_user.students << student
      if current_user.save
        student.enable!
        current_user.enable!
        student.forgot_password!
        SetStudentPasswordMailer.set_password(student).deliver_now
      end
    else
      #Do not create student but save engagement info
    end

    student_id = student.id if student
    engagement = Engagement.new(
      student_id: student_id,
      student_name: student_name,
      # The below will be replaced by subject_id when client_info goes away
      subject: current_user.client_info.subject,
      client_id: current_user.id,
      academic_type: user_academic_type
    )

    if engagement.save
      redirect_to dashboard_path
    else
      redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: current_user.errors.full_messages })
    end
  end

  def profile
    if(params[:dwolla_error])
      @dwolla_error = "Please authenticate with our payment processor Dwolla to ensure payment."
    end

    @availability_engagement = current_user&.student_engagements&.first || current_user&.client_engagements&.first
  end

  private

  def student_email_provided?
    # If client has a student and if a student email has been given
    user_params[:student] &&
    user_params[:student][:email].present? &&
    user_params[:student][:email] != user_params[:email]
  end

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

  def user_academic_type
    if current_user.is_student?
      client_as_student_info_params[:academic_type]
    else
      params[:student_academic_type]
    end
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number, :password, client_info_attributes: [:id])
  end

  def update_params
    params.require(:user).permit(:name, :phone_number)
  end
end
