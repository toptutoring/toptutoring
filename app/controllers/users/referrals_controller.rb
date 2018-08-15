module Users
  class ReferralsController < ApplicationController
    layout "authentication"
    def show
      @user = User.new
      @user.build_signup
      @referrer = User.find_by(unique_token: unique_token)
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
        @referrer = @user.referrer
        render :show
      end
    end

    private

    def unique_token
      params.require(:unique_token)
    end

    def signups_params
      params.require(:user)
            .permit(:first_name, :last_name, :phone_number, :email, 
                    :password, :referrer_id, :zip,
                    signup_attributes: [:student, :subject_id, :comments])
            .merge(roles: Role.where(name: "client"), country_code: "US")
    end

    def confirm_password
      params.require(:confirm_password)
    end

    def return_path(user)
      user.signup.student ? dashboard_path : new_clients_student_path
    end
  end
end
