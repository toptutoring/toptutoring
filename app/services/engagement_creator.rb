class EngagementCreator
  def initialize(user, params, client)
    @user = user
    @academic_type = client ? student_info.academic_type : params[:academic_type]
    @subject = client ? student_info.subject : params[:subject]
    @student_id = client ? student.id : @user.id
    @client = client
  end

  def perform
    enable_user
    create_engagement
  end

  private

  def enable_user
    @user.enable!
    student.enable! if @client
  end

  def create_engagement
    Engagement.create(
      student_id: @student_id,
      subject: @subject,
      client_id: @user.id,
      academic_type: @academic_type
    )
  end

  def student
    @user.students.last
  end

  def student_info
    student.student_info
  end
end
