class EnableUserAsStudent
  def initialize(user, params)
    @user = user
    @params = params
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
      subject: @params[:subject],
      client_id: @user.id,
      academic_type: @params[:academic_type]
    )
  end
end
