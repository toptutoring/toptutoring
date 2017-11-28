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
    ActiveRecord::Base.transaction do
      set_student_info unless @user.is_student?
      process_engagement
    end
    success
  rescue ActiveRecord::RecordInvalid => e
    failure(e)
  end

  def process_engagement
    @user.enable!
    engagement = create_engagement
  end

  def check_phone_number_and_update_client
    return false unless phone_number_valid?
    @user.update_attribute(:phone_number, @params[:phone_number])
  end

  def phone_number_valid?
    @params[:phone_number].length > 1
  end

  def set_student_info
    if student_email_provided? && !student_email_matches_client?
      save_and_email_student_user
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

  def save_and_email_student_user
    student = User.create!(student_params)
    student.enable!
    @student_account = StudentAccount.create!(student_account_params(student))
    SetStudentPasswordMailer.mail_student(student).deliver_later
    Result.new(true)
  end

  def student_account_params(student_user = nil)
    { name: @params[:student][:name],
      client_account: @user.client_account,
      user: student_user }
  end

  def student_params
    { email: @params[:student][:email],
      name: @params[:student][:name],
      password: SecureRandom.hex(10),
      client: @user,
      roles: Role.where(name: 'student') }
  end

  def set_student_without_creating_account
    @student_account = StudentAccount.create!(student_account_params)
  end

  def create_engagement
    subject = Subject.find_by_name(@user.signup.subject)
    Engagement.create!(
      student_account: @student_account || @user.student_account,
      subject: subject,
      client_id: @user.id,
    )
  end

  def success
    message = I18n.t("app.signup.success_message")
    Result.new(true, message)
  end

  def failure(message)
    Result.new(false, message)
  end
end
