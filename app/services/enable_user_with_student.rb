class EnableUserWithStudent
  def initialize(user)
    @user = user
  end

  def perform
    enable_users
    create_assignment
  end

  private

  def enable_users
    @user.enable!
    @user.students.last.enable!
  end

  def create_assignment
    Assignment.create(
      student_id: @user.students.last.id,
      subject: @user.students.last.student_info.subject)
  end
end
