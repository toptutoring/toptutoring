class EngagementCreator
  def initialize(user, params, client)
    @user = user
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

    remove_student_if_not_unique

    @user.enable!
    student.enable! if @client
  end

  def create_engagement
    Engagement.create(
      student_id: @student_id,
      subject: @subject,
      client_id: @user.id,
    )
  end

  def student
    @user.students.last
  end

  def student_info
    student.student_info
  end

  def remove_student_if_not_unique
    if !student.nil?
      if student.email == @user.email
        student.destroy
      end
    end
  end

end
