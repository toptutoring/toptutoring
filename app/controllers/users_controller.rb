class UsersController < Clearance::SessionsController
  before_action :require_login
  protect_from_forgery except: [:email_is_unique]

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def profile_update
    User.find(current_user.id).update(update_params)
    redirect_to profile_path, flash: { success: "Your profile has been updated." } and return
  end

  def update
    current_user.update_attribute(
      :phone_number, user_params[:phone_number])

    if student_email_provided? && !student_email_matches_client?
      student_name = user_params[:student][:name]
      student_email = user_params[:student][:email]
      student = User.create(
        email: student_email,
        name: student_name,
        password: SecureRandom.hex(10),
        roles: 'student'
      )
      current_user.students << student
      if current_user.save
        student.enable!
        student.forgot_password!
        SetStudentPasswordMailer.set_password(student).deliver_now
      end
    else
      #Do not create student but save engagement info
      if current_user.is_student?
        student_name = current_user.name
      else
        student_name = user_params[:student][:name]
      end
      student_id = current_user.id
    end

    current_user.enable!

    student_id = student.id if student
    engagement = Engagement.new(
      student_id: student_id,
      student_name: student_name,
      subject: current_user.signup.subject,
      client_id: current_user.id,
      academic_type: find_subject_type(current_user.signup.subject)
    )

    if engagement.save
      redirect_to dashboard_path
    else
      redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: current_user.errors.full_messages })
    end
  end

  def profile
    @availability_engagement = current_user&.student_engagements&.first || current_user&.client_engagements&.first
  end

  def email_is_unique
    @email_unique = student_email_unique?
    render :file => "users/email_is_unique.js.erb"
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

  def find_subject_type(subject_name)
    subject = Subject.find_by(name: subject_name)
    subject.academic? ? 'Academic' : 'Test Prep'
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number, :password, signup_attributes: [:id])
  end

  def update_params
    params.require(:user).permit(:name, :phone_number)
  end

  def student_email_matches_client?
    user_params[:student][:email].downcase == current_user.email
  end

  def student_email_unique?
    student_email = params[:user_student_email]
    if student_email.downcase == current_user.email
      true
    else
      (User.where(email: student_email).first).nil?
    end
  end
end
