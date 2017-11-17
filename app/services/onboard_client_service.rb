class OnboardClientService
  def initialize(user, params)
    @user = user
    @params = params
  end

  Result = Struct.new(:success?, :message)

  # This method returns a hash with keys :success?, and :message
  def onboard_client!
    if check_phone_number_and_update_client
      set_student_info
      @user.enable!
      engagement = create_engagement
      engagement.persisted? ? success : failure(engagement.errors.messages)
    else
      failure "Please input a valid phone number."
    end
  end

  private

  def check_phone_number_and_update_client
    return false unless phone_number_valid?
    @user.update_attribute(:phone_number, @params[:phone_number])
  end

  def phone_number_valid?
    @params[:phone_number].length > 1
  end

  def set_student_info
    if student_email_provided? && !student_email_matches_client?
      create_and_email_student_user
    else
      set_student_without_creating_account
    end
  end

  def student_email_provided?
    # If client has a student and if a student email has been given
    @params[:student] &&
    @params[:student][:email].present? &&
    @params[:student][:email] != @params[:email]
  end

  def student_email_matches_client?
    @params[:student][:email].downcase == @user.email
  end

  def create_and_email_student_user
    @student = User.create(student_params)
    @user.students << @student
    if @user.save
      @student.enable!
      @student.forgot_password!
      SetStudentPasswordMailer.set_password(@student).deliver_now
    end
  end

  def student_params
    @student_name = @params[:student][:name]
    { email: @params[:student][:email],
      name: @student_name,
      password: SecureRandom.hex(10),
      roles: Role.where(name: 'student') }
  end

  def set_student_without_creating_account
    if @user.is_student?
      @student_name = @user.name
    else
      @student_name = @params[:student][:name]
    end
    @student = @user
  end

  def create_engagement
    Engagement.create(
      student_id: @student.id,
      student_name: @student_name,
      subject: @user.signup.subject,
      client_id: @user.id,
      academic_type: find_subject_type(@user.signup.subject)
    )
  end

  def find_subject_type(subject_name)
    subject = Subject.find_by(name: subject_name)
    subject.academic? ? 'Academic' : 'Test Prep'
  end

  def success
    message = "Thank you for finishing the sign up process!" \
      " We are in the process of finding a great tutor for you." \
      " If you have any questions in the mean time, feel free to contact us!"
    Result.new(true, message)
  end

  def failure(message)
    Result.new(false, message)
  end
end
