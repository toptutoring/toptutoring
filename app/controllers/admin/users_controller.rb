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
      flash.notice = t("app.admin.users.remove_user_success", name: user.full_name)
      redirect_to admin_users_path
    rescue ActiveRecord::ActiveRecordError => e
      flash.alert = t("app.admin.users.remove_user_failure")
      redirect_to admin_users_path
    end

    def archive
      @user = User.find(params[:id])
      @user.archived = true
      if @user.save!
        archive_engagements
        flash.now[:notice] = "#{@user.full_name} has been archived"
      else
        flash.now[:alert] = @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number,
                                   :in_person_academic_credit, :in_person_test_prep_credit,
                                   :in_person_academic_rate, :in_person_test_prep_rate,
                                   :online_test_prep_credit, :online_academic_credit,
                                   :online_test_prep_rate, :online_academic_rate)
    end

    def archive_engagements
        @user.client_account
             .engagements.update_all(state: "archived") if @user.client_account
        @user.student_account
             .engagements.update_all(state: "archived") if @user.student_account
        @user.tutor_account
             .engagements.update_all(state: "archived") if @user.tutor_account
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
