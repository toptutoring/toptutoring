class EnableUser
  def initialize(user)
    @user = user
  end

  def perform
    enable_user
    create_assignment
  end

  private

  def enable_user
    #@user.enable!
  end

  def create_assignment
    Assignment.create(
      student_id: @user.student.id,
      subject: @user.student.subject,
      academic_type: @user.student.academic_type
    )
  end
end
