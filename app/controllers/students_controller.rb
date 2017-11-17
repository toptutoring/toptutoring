class StudentsController < ApplicationController
  before_action :require_login

  def new
    @student = current_user.students.build
  end

  def create
    @student = Clearance.configuration.user_model.new(student_params)
    @student.password = SecureRandom.hex(10)
    @student.client_id = current_user.id
    if @student.save
      if @student.email.present?
        @student.forgot_password!
        SetStudentPasswordMailer.set_password(@student.id).deliver_now
      end
      engagement = Engagement.new(
        student_id: @student.id,
        student_name: @student.name,
        client_id: current_user.id,
        subject: student_academic_info_and_subject[:subject],
        academic_type: student_academic_info_and_subject[:academic_type]
      )
      if engagement.save
        redirect_to students_path, notice: 'Student successfully created'
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: engagement.errors.full_messages })
      end
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @student.errors.full_messages })
    end
  end

  def index
    @engagements = current_user.client_engagements
  end

  private

  def student_params
    params.require(:user).permit(:name, :email, :phone_number).merge(roles: "student")
  end

  def student_academic_info_and_subject
    params.require(:info).permit(:academic_type, :subject)
  end

end
