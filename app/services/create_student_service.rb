class CreateStudentService
  def initialize(client)
    @client = client
  end

  Result = Struct.new(:success?, :messages)

  def process!(student_name, subject, student_params = nil)
    ActiveRecord::Base.transaction do
      create_student_account!(student_name)
      create_student_user!(student_params) if student_params
      create_engagement!(subject)
    end
    Result.new(true, I18n.t("app.add_student.success"))
  rescue ActiveRecord::RecordInvalid => e
    Result.new(false, e.message)
  end

  private

  def create_student_account!(name)
    @student_account = @client.client_account
                              .student_accounts
                              .create!(name: name)
  end

  def create_student_user!(params)
    student = User.create!(params)
    student.enable!
    student.forgot_password!
    SetStudentPasswordMailer.mail_student(student).deliver_later
  end

  def create_engagement!(subject)
    @engagement = Engagement.create!(
      student_account: @student_account,
      client_account: @client.client_account,
      subject: subject
    )
  end
end
