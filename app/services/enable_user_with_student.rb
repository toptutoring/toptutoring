class EnableUserWithStudent
  def initialize(user)
    @user = user
  end

  def perform
    enable_users
    create_engagement
  end

  private

  def enable_users
    @user.enable!
    @user.students.last.enable!
  end

  def create_engagement
    Engagement.create(
      student_id: @user.students.last.id,
      subject: @user.students.last.student_info.subject,
      client_id: @user.id,
      academic_type: @user.students.last.student_info.academic_type)
  end
end
