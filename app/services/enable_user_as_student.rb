class EnableUserAsStudent
  def initialize(user, academic_type, subject)
    @user = user
    @academic_type = academic_type
    @subject = subject
  end

  def perform
    enable_user
    create_engagement
  end

  private

  def enable_user
    @user.enable!
  end

  def create_engagement
    Engagement.create(
      student_id: @user.id,
      subject: @subject,
      client_id: @user.id,
      academic_type: @academic_type
    )
  end
end
