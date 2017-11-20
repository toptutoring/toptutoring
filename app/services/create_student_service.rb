class CreateStudentService
  def initialize(student, client)
    @student = student
    @client = client
  end

  Result = Struct.new(:success?, :messages)

  def create_student_and_engagement!(subject)
    ActiveRecord::Base.transaction do
      create_student!
      create_engagement!(subject)
    end
    Result.new(true, I18n.t("app.add_student.success"))
  rescue ActiveRecord::RecordInvalid => e
    Result.new(false, e.message)
  end

  def create_student!
    return unless @student.email.present?
    @student.password = SecureRandom.hex(10)
    @student.client_id = @client.id
    @student.save!
    @student.forgot_password!
    SetStudentPasswordMailer.mail_student(@student).deliver_later
  end

  def create_engagement!(subject)
    @engagement = Engagement.create!(
      student_id: @student.id || @client.id,
      student_name: @student.name,
      client_id: @client.id,
      subject: subject.name,
      academic_type: subject.academic_type
    )
  end
end
