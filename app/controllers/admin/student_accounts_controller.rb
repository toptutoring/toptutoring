module Admin
  class StudentAccountsController < ApplicationController
    def destroy
      account = StudentAccount.find(params[:id])
      account.destroy
      flash.notice = "#{account.name}'s student account has been removed."
      redirect_to edit_admin_user_path(account.client)
    rescue ActiveRecord::ActiveRecordError => e
      flash.alert = e.message
      redirect_to edit_admin_user_path(account.client)
    end

    def create
      results = create_student!
      if results.success?
        flash.notice = results.messages
        redirect_to edit_admin_user_path(@client)
      else
        flash.alert = results.messages
        redirect_to edit_admin_user_path(@client)
      end
    end

    private

    def create_student!
      @client = User.find(params[:client_id])
      create_student_service = CreateStudentService.new(@client)
      create_student_service.process!(student_name, subject, student_user_params)
    end

    def student_user_params
      return nil unless params[:create_user_account] == "yes"
      params.require(:user).permit(:email)
            .merge(name: student_name, client_id: @client.id,
                   phone_number: @client.phone_number,
                   password: SecureRandom.hex(10),
                   roles: Role.where(name: "student"))
    end

    def student_name
      params.require(:name)
    end

    def subject
      Subject.find_by_id(params[:engagement][:subject_id])
    end
  end
end
