class StudentsController < ApplicationController
  before_action :require_login

  def new
    @student = current_user.students.build
    @student.build_student_info
  end

  def create
    @student = Clearance.configuration.user_model.new(student_params)
    @student.client_id = current_user.id
    if @student.save
      if @student.email.present?
        @student.forgot_password!
        SetStudentPasswordMailer.set_password(@student).deliver_now
      end
      Engagement.create(
        student_id: @student.id,
        client_id: current_user.id,
        subject: @student.student_info.subject,
        academic_type: @student.student_info.academic_type)
        redirect_to students_path, notice: 'Student successfully created'
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @student.errors.full_messages })
    end
  end

  def index
    @students = current_user.students
  end

  private

  def student_params
    params.require(:user).permit(:name, :email, :phone_number, student_info_attributes: [:id, :subject, :academic_type]).merge(password: rand(36**4).to_s(36), roles: "student")
  end

end
