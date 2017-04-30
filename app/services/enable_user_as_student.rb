class EnableUserAsStudent
  def initialize(user)
    @user = user
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
      subject: @user.client_info.subject,
      client_id: @user.id,
      academic_type: @user.client_info.subject
    )
  end
end
