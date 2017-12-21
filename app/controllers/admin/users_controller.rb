module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.all_without_admin.order(:id)
    end

    def edit
      @user_role = @user.roles.first.name.capitalize 
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to admin_users_path, notice: 'User successfully updated!'
      else
        flash.alert = @user.errors.full_messages
        redirect_to edit_admin_user_path(@user)
      end
    end

    def destroy
      user = User.find(params[:id]).destroy
      flash.notice = t("app.admin.users.remove_user_success", name: user.name)
      redirect_to admin_users_path
    rescue ActiveRecord::ActiveRecordError => e
      flash.alert = t("app.admin.users.remove_user_failure")
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :phone_number,
                                   :test_prep_credit, :academic_credit,
                                   :test_prep_rate, :academic_rate)
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
