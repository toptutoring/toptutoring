class UsersController < Clearance::SessionsController
  before_action :require_login
  protect_from_forgery except: [:email_is_unique]

  def edit
    if !current_user.is_student?
      current_user.students.build
    end
  end

  def update
    if check_phone_number_and_update_client
      set_student_info
      current_user.enable!
      create_engagement ? success_message : failure_message
    else
      flash.alert = "Please input a valid phone number."
    end
    redirect_to dashboard_path
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
    params.require(:user).permit(:name, :email, :phone_number, :password,
                                 student: [:id, :name, :email, 
                                           :phone_number, :password, :subject])
  end

  def find_subject_type(subject_name)
    subject = Subject.find_by(name: subject_name)
    subject.academic? ? 'Academic' : 'Test Prep'
  end

  def client_as_student_params
    params.require(:user).permit(:name, :email, :phone_number,
                                 :password, signup_attributes: [:id])
  end

  def student_email_matches_client?
    user_params[:student][:email].downcase == current_user.email
  end

  def student_email_unique?
    student_email = params[:user_student_email]
    if student_email.downcase == current_user.email
      true
    else
      User.where(email: student_email).first.nil?
    end
  end

  def check_phone_number_and_update_client
    return false unless phone_number_valid?
    current_user.update_attribute(:phone_number, user_params[:phone_number])
  end

  def phone_number_valid?
    user_params[:phone_number].length > 1
  end

  def set_student_info
    create_student_account = student_email_provided? && !student_email_matches_client?
    return create_and_email_student_user if create_student_account
    set_student_without_creating_account
  end

  def create_and_email_student_user
    @student = User.create(student_params)
    current_user.students << @student
    if current_user.save
      @student.enable!
      @student.forgot_password!
      SetStudentPasswordMailer.set_password(@student).deliver_now
    end
  end

  def student_params
    @student_name = user_params[:student][:name]
    { email: user_params[:student][:email],
      name: @student_name,
      password: SecureRandom.hex(10),
      roles: Role.where(name: 'student') }
  end

  def set_student_without_creating_account
    if current_user.is_student?
      @student_name = current_user.name
    else
      @student_name = user_params[:student][:name]
    end
    @student = current_user
  end

  def create_engagement
    @engagement = Engagement.new(
      student_id: @student.id,
      student_name: @student_name,
      subject: current_user.signup.subject,
      client_id: current_user.id,
      academic_type: find_subject_type(current_user.signup.subject)
    )
    @engagement.save
  end

  def success_message
    flash.notice = "Thank you for finishing the sign up process!" \
      " We are in the process of finding a great tutor for you." \
      " If you have any questions in the mean time, feel free to contact us!"
  end

  def failure_message
    flash[:error] = @engagement.errors.messages
  end
end
