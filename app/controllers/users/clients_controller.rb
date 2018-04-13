module Users
  class ClientsController < ApplicationController
    before_action :redirect_to_root, if: :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_signup
    end

    def create
      result = CreateClientService.create!(signups_params, confirm_password)
      if result.success?
        sign_in(result.user)
        flash.notice = result.messages
        redirect_to return_path(result.user)
      else
        flash.now[:alert] = result.messages
        @user = result.user
        render :new
      end
    end

    private

    def confirm_password
      params.require(:confirm_password)
    end

    def signups_params
      params.require(:user)
            .permit(:first_name, :last_name, :phone_number, :email, :password,
                    :zip, signup_attributes: [:student, :subject_id, :comments])
            .merge(roles: Role.where(name: "client"),
                   country_code: country_code)
    end

    def return_path(user)
      user.signup.student ? dashboard_path : new_clients_student_path
    end

    def redirect_to_root
      redirect_to root_path
    end
  end
end
