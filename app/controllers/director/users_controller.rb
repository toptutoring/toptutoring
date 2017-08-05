module Director
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.clients.order(:name)
    end

    def edit
      @user_role = @user.roles.first.name.capitalize
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to director_users_path, notice: 'Client info is successfully updated!'
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @user.errors.full_messages })
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :academic_rate_cents, :test_prep_rate_cents)
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
