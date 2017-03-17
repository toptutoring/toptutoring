class StudentsController < ApplicationController
  before_action :require_login

  def create
    @user = Clearance.configuration.user_model.new(student_params)
    @user.client_id = current_user.id
    if @user.save
      @user.forgot_password!
      SetStudentPasswordMailer.set_password(@user).deliver_now
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { notice: 'Student successfully created' })
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
    params.require(:user).permit(:name, :email, :phone_number).merge(password: rand(36**4).to_s(36), roles: "student")
  end

end
