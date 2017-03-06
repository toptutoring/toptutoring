module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.with_parent_role.assigned
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to admin_users_path, notice: 'User successfully updated!'
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @user.errors.full_messages })
      end
    end

    private

    def user_params
      params.require(:user).permit(:balance, student_attributes: [:name, :email, :subject, :academic_type, :id])
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
