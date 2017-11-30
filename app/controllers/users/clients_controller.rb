module Users
  class ClientsController < ApplicationController
    before_action :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_signup
    end

    def create
      result = CreateClientService.create!(signups_params)
      if result.success?
        sign_in(result.user)
        redirect_to :root
      else
        flash.alert = result.messages
        redirect_back fallback_location: (client_sign_up_path)
      end
    end

    private

    def signups_params
      params.require(:user)
            .permit(:name, :email, :password,
                    signup_attributes: [:student, :subject, :comments])
            .merge(roles: Role.where(name: "client"))
    end

    def redirect_to_root
      redirect_to root_path
    end
  end
end
