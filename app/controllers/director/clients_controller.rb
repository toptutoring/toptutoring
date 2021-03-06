module Director
  class ClientsController < ApplicationController
    before_action :require_login

    def index
      @users = User.clients.order(:first_name)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.clients.find(params[:id])

      if valid_inputs? && @user.update_attributes(user_params)
        result = SwapClientService.new(@user, @engagement).swap!
        if result.success?
          redirect_to director_clients_path, notice: "Client info is successfully updated! #{result.messages}"
        else
          flash[:error] = "#{result.messages}"
          render "edit"
        end
      else
        flash[:error] = @user.errors.full_messages
        render "edit"
      end
    end

    private

    def user_params
      params.require(:user).permit(:online_academic_credit, :online_test_prep_credit,
                                   :online_academic_rate, :online_test_prep_rate,
                                   :in_person_academic_credit, :in_person_test_prep_credit,
                                   :in_person_academic_rate, :in_person_test_prep_rate,
                                   :referrer_id, :referral_claimed, :switch_to_student,
                                   client_account_attributes: [:id, :review_source, :review_link])
    end

    def valid_inputs?
      valid_amount? && valid_credit?
    end

    def valid_amount?
      return true if money?(params[:user][:online_academic_rate]) &&
                     money?(params[:user][:online_test_prep_rate]) &&
                     money?(params[:user][:in_person_academic_rate]) &&
                     money?(params[:user][:in_person_test_prep_rate])
      flash.now[:alert] = "Rates must be in correct dollar values"
      false
    end

    def valid_credit?
      return true if quarter_hours?(params[:user][:online_academic_credit]) &&
                     quarter_hours?(params[:user][:online_test_prep_credit]) &&
                     quarter_hours?(params[:user][:in_person_academic_credit]) &&
                     quarter_hours?(params[:user][:in_person_test_prep_credit])
      flash.now[:alert] = "Credits must be in quarter hours"
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
