module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.all_without_admin.view_order
    end

    def update
      if @user.update_attributes(user_params)
        flash.now.notice = 'User successfully updated!'
      else
        flash.now.alert = @user.errors.full_messages
      end
      render :edit
    end

    def destroy
      @user = User.find(params[:id])
      @user.client_account.engagements.destroy_all if @user.client_account.present?

      @user.students.destroy_all
      full_name = @user.full_name
      @user.destroy!
      flash.now.notice = t("app.admin.users.remove_user_success", name: full_name)
    rescue ActiveRecord::ActiveRecordError => e
      flash.now.alert = t("app.admin.users.remove_user_failure")
    end

    def archive
      @user = User.find(params[:id])
      @user.archived = true
      if @user.save!
        archive_engagements
        flash.now.notice = "#{@user.full_name} has been archived"
      else
        flash.now.alert = @user.errors.full_messages
      end
    end

    def reactivate
      @user = User.find(params[:id])
      @user.archived = false
      if @user.save
        flash.now.notice = "#{@user.full_name} has been reactivated."
      else
        flash.now.alert = @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number,
                                   :in_person_academic_credit, :in_person_test_prep_credit,
                                   :in_person_academic_rate, :in_person_test_prep_rate,
                                   :online_test_prep_credit, :online_academic_credit,
                                   :online_test_prep_rate, :online_academic_rate,
                                   :referrer_id, :referral_claimed,
                                   client_account_attributes: [:id, :review_source, :review_link])
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
