module Admin
  class TutorsController < ApplicationController
    before_action :require_login
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.with_tutor_role
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to admin_tutors_path, notice: 'Tutor successfully updated!'
      else
        redirect_to :back, flash: { error: @user.errors.full_messages }
      end
    end

    private

    def user_params
      params.require(:user).permit(:balance, tutor_attributes: [:subject, :academic_type, :id, :hourly_rate])
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
