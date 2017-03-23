class StudentsController < ApplicationController
  before_action :require_login

  def new
    @student = current_user.students.build
    @student.build_student_info
  end

  def create
    @user = Clearance.configuration.user_model.new(student_params)
    @user.client_id = current_user.id
    if @user.save
      if @user.email.present?
        @user.forgot_password!
        SetStudentPasswordMailer.set_password(@user).deliver_now
      end
      Assignment.create(
        student_id: @user.id,
        subject: @user.student_info.subject)
        redirect_to students_path, notice: 'Student successfully created'
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @user.errors.full_messages })
    end
  end

  def index
    @students = current_user.students
  end

  private

  def student_params
    params.require(:user).permit(:name, :email, :phone_number, student_info_attributes: [:id, :subject]).merge(password: rand(36**4).to_s(36), roles: "student")
  end

end
