module Clients
  class StudentsController < ApplicationController
    before_action :require_login

    def create
      results = create_student!
      if results.success?
        flash.notice = results.messages
        redirect_to clients_students_path
      else
        flash.alert = results.messages
        render :new
      end
    end

    def index
      @student_accounts = current_user.client_account.student_accounts
      render :new if @student_accounts.empty?
    end

    def show
      @student = User.find params[:id]
    end

    private

    def create_student!
      create_student_service = CreateStudentService.new(current_user)
      create_student_service.process!(student_name, subject, student_params)
    end

    def student_params
      return nil unless params[:create_user_account] == "yes"
      params.require(:user).permit(:email)
            .merge(name: student_name, client_id: current_user.id,
                   phone_number: current_user.phone_number,
                   password: SecureRandom.hex(10),
                   roles: Role.where(name: "student"))
    end

    def student_name
      params.require(:name)
    end

    def subject
      Subject.find(params[:engagement][:subject_id])
    end
  end
end
