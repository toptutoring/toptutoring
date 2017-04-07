module Users
  class ClientsController < ApplicationController
    before_action :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_client_info
    end

    def create
      @user = Clearance.configuration.user_model.new(signups_params)
      if @user.save
        UserNotifierMailer.send_signup_email(@user).deliver_now
        NewClientNotifierMailer.welcome(@user, User.admin_and_directors).deliver_now
        sign_in(@user)
        redirect_to :root
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @user.errors.full_messages })
      end
    end

    private

    def signups_params
      params.require(:user).permit(:name, :email, :password,  client_info_attributes: [:tutoring_for, :subject, :comments]).merge(roles: "client")
    end

    def redirect_to_root
      redirect_to root_path
    end
  end
end
