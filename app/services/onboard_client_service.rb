class OnboardClientService
  def initialize(user, params)
    @user = user
    @params = params
  end

  Result = Struct.new(:success?, :message)

  def onboard_client!
    ActiveRecord::Base.transaction do
      update_phone_number
      set_student_info unless @user.signup.student
      process_engagement
    end
    return_results(true, I18n.t("app.signup.success_message"))
  rescue ActiveRecord::RecordInvalid => e
    return_results(false, e)
  end

  def process_engagement
    @user.enable!
    engagement = create_engagement
  end

  def update_phone_number
    @user.update_attributes!(phone_number: @params[:phone_number])
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
    student_params.merge!(phone_number: @user.phone_number)
    student = User.create!(student_params)
    student.enable!
    @student_account = StudentAccount.create!(student_account_params(student))
    SetStudentPasswordMailer.mail_student(student).deliver_later
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
      roles: Role.where(name: "student") }
  end

  def set_student_without_creating_account
    @student_account = StudentAccount.create!(student_account_params)
  end

  def create_engagement
    Engagement.create!(
      client_account: @user.client_account,
      student_account: @student_account || @user.student_account,
      subject: @user.signup.subject
    )
  end

  def return_results(result, message)
    SlackNotifier.notify_user_signed_up(@user)
    Result.new(true, message)
  end
end
