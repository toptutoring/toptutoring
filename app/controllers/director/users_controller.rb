module Director
  class UsersController < ApplicationController
    before_action :require_login

    def index
      @users = User.clients.order(:name)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if valid_inputs? && @user.update_attributes(user_params)
        redirect_to director_users_path, notice: 'Client info is successfully updated!'
      else
        flash[:error] = @user.errors.full_messages
        render "edit"
      end
    end

    private

    def user_params
      params.require(:user).permit(:academic_credit, :test_prep_credit,
                                   :academic_rate, :test_prep_rate)
    end

    def valid_inputs?
      valid_amount? && valid_credit?
    end

    def valid_amount?
      return true if money?(params[:user][:academic_rate]) &&
                     money?(params[:user][:test_prep_rate])
      flash.alert = "Rates must be in correct dollar values"
      false
    end

    def valid_credit?
      return true if quarter_hours?(params[:user][:academic_credit]) &&
                     quarter_hours?(params[:user][:test_prep_credit])
      flash.alert = "Credits must be in quarter hours"
      false
    end

    def money?(value)
      value.to_money.to_s == value || value.to_money.to_i.to_s == value
    end

    def quarter_hours?(value)
      (value.to_f % 0.25).zero?
    end
  end
end
