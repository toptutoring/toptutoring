class StudentsController < ApplicationController
  before_action :require_login

  def new
    @student = current_user.students.build
  end

  def create
    @student = Clearance.configuration.user_model.new(student_params)
    results = process_request(@student)
    if results.success?
      flash.notice = results.messages
      redirect_to students_path
    else
      flash.alert = results.messages
      render :new
    end
  end

  def index
    @engagements = current_user.client_engagements
  end

  private

  def process_request(student)
    create_student_service = CreateStudentService.new(student, current_user)
    create_student_service.create_student_and_engagement!(subject)
  end

  def student_params
    params.require(:user).permit(:name, :email).merge(roles: Role.where(name: "student"))
  end

  def subject
    Subject.find(params[:engagement][:subject])
  end
end
