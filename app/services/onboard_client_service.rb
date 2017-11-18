class OnboardClientService
  def initialize(user, params)
    @user = user
    @params = params
  end

  Result = Struct.new(:success?, :message)

  def onboard_client!
    if check_phone_number_and_update_client
      process_student_and_engagement
    else
      failure I18n.t("app.signup.phone_validation")
    end
  end

  private

  def process_student_and_engagement
    if @user.is_student?
      process_engagement(@user)
    elsif set_student_info
      process_engagement(@student)
    else
      failure(@student.errors.full_messages)
    end
  end

  def process_engagement(student)
    @user.enable!
    engagement = create_engagement(student)
    engagement.persisted? ? success : failure(engagement.errors.full_messages)
  end

  def check_phone_number_and_update_client
    return false unless phone_number_valid?
    @user.update_attribute(:phone_number, @params[:phone_number])
  end

  def phone_number_valid?
    @params[:phone_number].length > 1
  end

  def set_student_info
    set_student_without_creating_account
    if student_email_provided? && !student_email_matches_client?
      save_and_email_student_user
    else
      true
    end
  end

  def student_email_provided?
    # If client has a student and if a student email has been given
    @params[:student] &&
      @params[:student][:email].present? &&
      @params[:student][:email] != @params[:email]
  end

  def set_student_without_creating_account
    @student = User.new(student_params)
  end

  def student_email_matches_client?
    @params[:student][:email].downcase == @user.email
  end

  def save_and_email_student_user
    return false unless @student.save
    @user.students << @student
    @student.enable!
    @student.forgot_password!
    SetStudentPasswordMailer.set_password(@student).deliver_now
    true
  end

  def student_params
    @student_name = @params[:student][:name]
    { email: @params[:student][:email],
      name: @student_name,
      password: SecureRandom.hex(10),
      roles: Role.where(name: 'student') }
  end

  def create_engagement(student)
    Engagement.create(
      student_id: student.id || @user.id,
      student_name: student.name,
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
    message = I18n.t("app.signup.success_message")
    Result.new(true, message)
  end

  def failure(message)
    Result.new(false, message)
  end
end
